# Generalized Pareto maximum likelihood for threshold exceedances.
# Install once: install.packages("mev")
# Load: source("gpd_mle.R")
#
# Parameterization for excess z >= 0:
# S(z) = (1 + shape*z/scale)^(-1/shape), scale > 0;
# S(z) = exp(-z/scale) when shape = 0.
# Support requires 1 + shape*z/scale > 0.
# Threshold is FIXED by the caller, not estimated as a location parameter.
# mev's Grimshaw method searches shape >= -1, including the boundary;
# unrestricted GPD likelihood can be unbounded for shape < -1.
# Documentation: https://lbelzile.github.io/mev/reference/fit.gpd.html
#
# Examples (replace x / permutation_ratios with your numeric vectors):
#   fit <- fit_gpd_mle(x, threshold = 2, tail = "upper")
#   fit$parameters
#   gpd_tail_probability(fit, 5)
#
# Lower tail for CV MSE ratios (small ratios are more significant):
#   u <- unname(quantile(permutation_ratios, 0.20))
#   fit <- fit_gpd_mle(permutation_ratios, u, tail = "lower")
#   fit$parameters
#   gpd_tail_probability(fit, observed_ratio)
# The 20% threshold is illustrative, not a recommended universal choice.
# Choose/check thresholds using substantially more permutations if possible.
#
# If x already contains strictly positive excesses, use threshold = 0.
# Then probabilities describe the excess distribution, not the original
# unconditional distribution unless all original observations exceeded u.

fit_gpd_mle <- function(x, threshold, tail = c("upper", "lower")) {
  tail <- match.arg(tail)
  if (!is.numeric(x) || !is.null(dim(x)) || length(x) < 3L ||
      any(!is.finite(x))) {
    stop("x must be a numeric vector with at least 3 finite observations.")
  }
  if (!is.numeric(threshold) || length(threshold) != 1L ||
      !is.finite(threshold)) stop("threshold must be one finite number.")
  if (!requireNamespace("mev", quietly = TRUE)) {
    stop('Install the required package first: install.packages("mev")')
  }

  # Reflect a lower-tail problem into an upper-tail problem.
  direction <- if (tail == "upper") 1 else -1
  y <- direction * x
  u <- direction * threshold
  excess <- y[y > u] - u
  m <- length(excess)
  if (m < 3L) stop("At least 3 strict threshold exceedances are required.")
  if (length(unique(excess)) < 2L) stop("Tail excesses must not all be equal.")
  if (m < 30L) {
    warning("Only ", m, " tail observations: shape and extrapolated probabilities ",
            "may be very unstable. 30 is a warning threshold, not a guarantee.")
  }

  raw <- mev::fit.gpd(xdat = y, threshold = u,
                      method = "Grimshaw", show = FALSE, warnSE = TRUE)
  if (!is.null(raw$convergence) &&
      any(!is.finite(raw$convergence) | raw$convergence != 0)) {
    stop("GPD optimization did not converge; inspect the data and threshold.")
  }
  # The documented estimate order is scale, shape.
  parameters <- setNames(as.numeric(raw$estimate), c("scale", "shape"))
  if (length(parameters) != 2L || any(!is.finite(parameters)) ||
      parameters[["scale"]] <= 0) stop("Invalid parameter estimates returned.")
  if (parameters[["shape"]] <= -0.5) {
    warning("Shape <= -0.5: usual asymptotic normal standard errors are unreliable.")
  }
  structure(list(parameters = parameters, threshold = threshold, tail = tail,
                 n = length(x), n_tail = m, tail_fraction = m / length(x),
                 excesses = excess, logLik = -raw$nllh, raw_fit = raw),
            class = "gpd_tail_mle")
}

# Unconditional tail probabilities for points AT or BEYOND the threshold.
# Upper tail: P(X > value); lower tail: P(X < value).
# These are model-based plug-in probabilities, not exact permutation p-values.
# Parameter uncertainty and uncertainty in the tail fraction are not included.
gpd_tail_probability <- function(fit, value, log.p = FALSE) {
  if (!inherits(fit, "gpd_tail_mle")) stop("Use a fit from fit_gpd_mle().")
  if (!is.numeric(value) || any(!is.finite(value))) {
    stop("value must contain finite numeric values.")
  }
  if (!is.logical(log.p) || length(log.p) != 1L || is.na(log.p)) {
    stop("log.p must be TRUE or FALSE.")
  }
  z <- if (fit$tail == "upper") value - fit$threshold else fit$threshold - value
  if (any(z < 0)) stop("Requested values must lie at or beyond the fitted threshold.")
  sigma <- fit$parameters[["scale"]]
  xi <- fit$parameters[["shape"]]
  r <- z / sigma
  if (xi == 0) {
    log_survival <- -r
  } else {
    a <- xi * r
    outside <- a <= -1
    log_survival <- rep(-Inf, length(z))
    inside <- !outside
    # log1p preserves accuracy near the exponential limit.
    log_survival[inside] <- -log1p(a[inside]) / xi
    if (any(outside)) {
      warning("Value reaches/exceeds the fitted finite endpoint: probability is ",
              "zero under this fitted model, not evidence of an exact zero p-value.")
    }
  }
  log_probability <- log(fit$tail_fraction) + log_survival
  if (log.p) log_probability else exp(log_probability)
}
