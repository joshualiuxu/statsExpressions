#' @title Template for subtitles with statistical details for tests
#' @name expr_template
#'
#' @param no.parameters An integer that specifies that the number of parameters
#'   for the statistical test. Can be `0` for non-parametric tests, `1` for
#'   tests based on *t*-statistic or chi-squared statistic, `2` for tests based
#'   on *F*-statistic.
#' @param stats.df A dataframe containing details from the statistical analysis
#'   and should contain some of the the following columns:
#' \itemize{
#'   \item *statistic*: the numeric value of a statistic.
#'   \item *parameter*: the numeric value of a parameter being modeled (often
#' degrees of freedom for the test); note that if `no.parameters = 0L` (e.g.,
#' for non-parametric tests), this column will be irrelevant.
#'   \item *parameter1*, *parameter2* relevant only if the statistic in question
#' has two degrees of freedom (e.g., anova).
#'   \item *p.value* the two-sided *p*-value associated with the observed
#' statistic.
#'  \item *estimate*: estimated value of the effect size.
#'   \item *conf.low*:  lower bound for effect size estimate.
#'   \item *conf.high*: upper bound for effect size estimate.
#' }
#' @param statistic.text A character that specifies the relevant test statistic.
#'   For example, for tests with *t*-statistic, `statistic.text = "t"`. If you
#'   want to use plotmath, you will have to quote the argument (e.g.,
#'   `quote(italic("t"))`).
#' @param effsize.text A character that specifies the relevant effect size.
#'   For example, for Cohen's *d* statistic, `effsize.text = "d"`. If you
#'   want to use plotmath, you will have to quote the argument (e.g.,
#'   `quote(italic("d"))`).
#' @param k Number of digits after decimal point (should be an integer)
#'   (Default: `k = 2L`).
#' @param k.parameter,k.parameter2 Number of decimal places to display for the
#'   parameters (default: `0`).
#' @param n An integer specifying the sample size used for the test.
#' @param n.text A character that specifies the design, which will determine
#'   what the `n` stands for. For example, for repeated measures, this can be
#'   `quote(italic("n")["pairs"])`, while for independent subjects design this
#'   can be `quote(italic("n")["obs"])`. If `NULL`, defaults to generic
#'   `quote(italic("n"))`.
#' @param ... Currently ignored.
#' @inheritParams expr_anova_parametric
#'
#' @importFrom rlang is_null
#' @importFrom ipmisc format_num
#'
#' @examples
#' set.seed(123)
#'
#' # creating a dataframe with stats results
#' stats_df <-
#'   cbind.data.frame(
#'     statistic = 5.494,
#'     parameter = 29.234,
#'     p.value = 0.00001,
#'     estimate = -1.980,
#'     conf.low = -2.873,
#'     conf.high = -1.088
#'   )
#'
#' # subtitle for *t*-statistic with Cohen's *d* as effect size
#' statsExpressions::expr_template(
#'   no.parameters = 1L,
#'   stats.df = stats_df,
#'   statistic.text = quote(italic("t")),
#'   effsize.text = quote(italic("d")),
#'   n = 32L,
#'   conf.level = 0.95,
#'   k = 3L,
#'   k.parameter = 3L
#' )
#' @export

# function body
expr_template <- function(no.parameters,
                          statistic.text,
                          stats.df,
                          effsize.text,
                          n,
                          conf.level = 0.95,
                          k = 2L,
                          k.parameter = 0L,
                          k.parameter2 = 0L,
                          n.text = quote(italic("n")),
                          ...) {
  # rename effect size column
  if ("effsize" %in% names(stats.df)) stats.df %<>% dplyr::rename(estimate = effsize)

  # ------------------ statistic with 0 degrees of freedom --------------------

  if (no.parameters == 0L) {
    # preparing subtitle
    subtitle <-
      substitute(
        expr = paste(
          statistic.text,
          " = ",
          statistic,
          ", ",
          italic("p"),
          " = ",
          p.value,
          ", ",
          effsize.text,
          " = ",
          effsize.estimate,
          ", CI"[conf.level],
          " [",
          effsize.LL,
          ", ",
          effsize.UL,
          "]",
          ", ",
          n.text,
          " = ",
          n
        ),
        env = list(
          statistic.text = statistic.text,
          statistic = format_num(stats.df$statistic[[1]], k),
          p.value = format_num(stats.df$p.value[[1]], k = k, p.value = TRUE),
          effsize.text = effsize.text,
          effsize.estimate = format_num(stats.df$estimate[[1]], k),
          conf.level = paste0(conf.level * 100, "%"),
          effsize.LL = format_num(stats.df$conf.low[[1]], k),
          effsize.UL = format_num(stats.df$conf.high[[1]], k),
          n = .prettyNum(n),
          n.text = n.text
        )
      )
  }

  # ------------------ statistic with 1 degree of freedom --------------------

  if (no.parameters == 1L) {
    if ("df" %in% names(stats.df)) stats.df %<>% dplyr::rename("parameter" = "df")
    if ("df.error" %in% names(stats.df)) stats.df %<>% dplyr::rename("parameter" = "df.error")

    # preparing subtitle
    subtitle <-
      substitute(
        expr = paste(
          statistic.text,
          "(",
          parameter,
          ") = ",
          statistic,
          ", ",
          italic("p"),
          " = ",
          p.value,
          ", ",
          effsize.text,
          " = ",
          effsize.estimate,
          ", CI"[conf.level],
          " [",
          effsize.LL,
          ", ",
          effsize.UL,
          "]",
          ", ",
          n.text,
          " = ",
          n
        ),
        env = list(
          statistic.text = statistic.text,
          statistic = format_num(stats.df$statistic[[1]], k),
          parameter = format_num(stats.df$parameter[[1]], k = k.parameter),
          p.value = format_num(stats.df$p.value[[1]], k = k, p.value = TRUE),
          effsize.text = effsize.text,
          effsize.estimate = format_num(stats.df$estimate[[1]], k),
          conf.level = paste0(conf.level * 100, "%"),
          effsize.LL = format_num(stats.df$conf.low[[1]], k),
          effsize.UL = format_num(stats.df$conf.high[[1]], k),
          n = .prettyNum(n),
          n.text = n.text
        )
      )
  }

  # ------------------ statistic with 2 degrees of freedom -----------------

  if (no.parameters == 2L) {
    # renaming pattern from `easystats`
    stats.df %<>%
      dplyr::rename_all(
        .tbl = .,
        .funs = dplyr::recode,
        df = "parameter1",
        df.error = "parameter2"
      )

    # preparing subtitle
    subtitle <-
      substitute(
        expr = paste(
          statistic.text,
          "(",
          parameter1,
          ",",
          parameter2,
          ") = ",
          statistic,
          ", ",
          italic("p"),
          " = ",
          p.value,
          ", ",
          effsize.text,
          " = ",
          effsize.estimate,
          ", CI"[conf.level],
          " [",
          effsize.LL,
          ", ",
          effsize.UL,
          "]",
          ", ",
          n.text,
          " = ",
          n
        ),
        env = list(
          statistic.text = statistic.text,
          statistic = format_num(stats.df$statistic[[1]], k),
          parameter1 = format_num(stats.df$parameter1[[1]], k = k.parameter),
          parameter2 = format_num(stats.df$parameter2[[1]], k = k.parameter2),
          p.value = format_num(stats.df$p.value[[1]], k = k, p.value = TRUE),
          effsize.text = effsize.text,
          effsize.estimate = format_num(stats.df$estimate[[1]], k),
          conf.level = paste0(conf.level * 100, "%"),
          effsize.LL = format_num(stats.df$conf.low[[1]], k),
          effsize.UL = format_num(stats.df$conf.high[[1]], k),
          n = .prettyNum(n),
          n.text = n.text
        )
      )
  }

  # return the formatted subtitle
  return(subtitle)
}

#' @noRd
#' @note Cleans outputs from `rcompanion` to make writing wrapper functions
#'   easier. This doesn't have much usage outside of this package context.
#'
#' @importFrom dplyr rename_all recode
#'
#' @keywords internal

# rename columns uniformly
rcompanion_cleaner <- function(object) {
  dplyr::rename_all(
    .tbl = as_tibble(object),
    .funs = dplyr::recode,
    epsilon.squared = "estimate",
    r = "estimate",
    W = "estimate",
    lower.ci = "conf.low",
    upper.ci = "conf.high"
  )
}

#' @name tidy_model_parameters
#' @title Convert `parameters` output to `tidymodels` convention
#'
#' @inheritParams parameters::model_parameters
#'
#' @importFrom parameters model_parameters
#' @importFrom insight standardize_names
#' @importFrom dplyr rename_all
#'
#' @examples
#' model <- lm(mpg ~ wt + cyl, data = mtcars)
#' tidy_model_parameters(model)
#' @export

tidy_model_parameters <- function(model, ...) {
  # extracting parameters
  df <- parameters::model_parameters(model, verbose = FALSE, ...)

  # special handling for t-test
  if ("Difference" %in% names(df)) df %<>% dplyr::select(-dplyr::matches("Diff|^CI"))

  # naming clean-up
  parameters::standardize_names(data = df, style = "broom") %>%
    dplyr::rename_all(~ gsub("omega2\\.|eta2\\.|cohens\\.|cramers\\.|d\\.|g\\.", "", .x)) %>%
    as_tibble(.)
}

#' @name tidy_model_performance
#' @title Convert `performance` output to `tidymodels` convention
#'
#' @inheritParams performance::model_performance
#'
#' @importFrom performance model_performance
#'
#' @examples
#' model <- lm(mpg ~ wt + cyl, data = mtcars)
#' tidy_model_parameters(model)
#' @export

tidy_model_performance <- function(model, ...) {
  performance::model_performance(model, verbose = FALSE, ...) %>%
    parameters::standardize_names(data = ., style = "broom") %>%
    as_tibble(.)
}


#' @noRd

.prettyNum <- function(x) prettyNum(x, big.mark = ",", scientific = FALSE)
