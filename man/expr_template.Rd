% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_miscellaneous.R
\name{expr_template}
\alias{expr_template}
\title{Template for subtitles with statistical details for tests}
\usage{
expr_template(
  no.parameters,
  statistic.text,
  stats.df,
  effsize.text,
  n,
  conf.level = 0.95,
  k = 2L,
  k.parameter = 0L,
  k.parameter2 = 0L,
  n.text = quote(italic("n")),
  ...
)
}
\arguments{
\item{no.parameters}{An integer that specifies that the number of parameters
for the statistical test. Can be \code{0} for non-parametric tests, \code{1} for
tests based on \emph{t}-statistic or chi-squared statistic, \code{2} for tests based
on \emph{F}-statistic.}

\item{statistic.text}{A character that specifies the relevant test statistic.
For example, for tests with \emph{t}-statistic, \code{statistic.text = "t"}. If you
want to use plotmath, you will have to quote the argument (e.g.,
\code{quote(italic("t"))}).}

\item{stats.df}{A dataframe containing details from the statistical analysis
and should contain some of the the following columns:
\itemize{
\item \emph{statistic}: the numeric value of a statistic.
\item \emph{parameter}: the numeric value of a parameter being modeled (often
degrees of freedom for the test); note that if \code{no.parameters = 0L} (e.g.,
for non-parametric tests), this column will be irrelevant.
\item \emph{parameter1}, \emph{parameter2} relevant only if the statistic in question
has two degrees of freedom (e.g., anova).
\item \emph{p.value} the two-sided \emph{p}-value associated with the observed
statistic.
\item \emph{estimate}: estimated value of the effect size.
\item \emph{conf.low}:  lower bound for effect size estimate.
\item \emph{conf.high}: upper bound for effect size estimate.
}}

\item{effsize.text}{A character that specifies the relevant effect size.
For example, for Cohen's \emph{d} statistic, \code{effsize.text = "d"}. If you
want to use plotmath, you will have to quote the argument (e.g.,
\code{quote(italic("d"))}).}

\item{n}{An integer specifying the sample size used for the test.}

\item{conf.level}{Scalar between 0 and 1. If unspecified, the defaults return
\verb{95\%} confidence/credible intervals (\code{0.95}).}

\item{k}{Number of digits after decimal point (should be an integer)
(Default: \code{k = 2L}).}

\item{k.parameter, k.parameter2}{Number of decimal places to display for the
parameters (default: \code{0}).}

\item{n.text}{A character that specifies the design, which will determine
what the \code{n} stands for. For example, for repeated measures, this can be
\code{quote(italic("n")["pairs"])}, while for independent subjects design this
can be \code{quote(italic("n")["obs"])}. If \code{NULL}, defaults to generic
\code{quote(italic("n"))}.}

\item{...}{Currently ignored.}
}
\description{
Template for subtitles with statistical details for tests
}
\examples{
set.seed(123)

# creating a dataframe with stats results
stats_df <-
  cbind.data.frame(
    statistic = 5.494,
    parameter = 29.234,
    p.value = 0.00001,
    estimate = -1.980,
    conf.low = -2.873,
    conf.high = -1.088
  )

# subtitle for *t*-statistic with Cohen's *d* as effect size
statsExpressions::expr_template(
  no.parameters = 1L,
  stats.df = stats_df,
  statistic.text = quote(italic("t")),
  effsize.text = quote(italic("d")),
  n = 32L,
  conf.level = 0.95,
  k = 3L,
  k.parameter = 3L
)
}
