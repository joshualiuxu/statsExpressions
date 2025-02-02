% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_miscellaneous.R
\name{tidy_model_performance}
\alias{tidy_model_performance}
\title{Convert \code{performance} output to \code{tidymodels} convention}
\usage{
tidy_model_performance(model, ...)
}
\arguments{
\item{model}{Statistical model.}

\item{...}{Arguments passed to or from other methods, resp. for
\code{compare_performance()}, one or multiple model objects (also of
different classes).}
}
\description{
Convert \code{performance} output to \code{tidymodels} convention
}
\examples{
model <- lm(mpg ~ wt + cyl, data = mtcars)
tidy_model_parameters(model)
}
