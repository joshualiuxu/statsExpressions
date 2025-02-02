# expr_anova_bayes works (between-subjects) ----------------------------

test_that(
  desc = "expr_anova_bayes works (between-subjects)",
  code = {
    skip_if(getRversion() < "3.6")

    # ggstatsplot output
    set.seed(123)
    using_function1 <-
      statsExpressions::expr_anova_bayes(
        data = statsExpressions::movies_long,
        x = genre,
        y = rating,
        k = 5,
        bf.prior = 0.8
      )

    # expected output
    set.seed(123)
    results1 <-
      tidyBF::bf_oneway_anova(
        data = statsExpressions::movies_long,
        x = genre,
        y = rating,
        k = 5,
        bf.prior = 0.8,
        output = "expression"
      )

    # testing overall call
    expect_identical(using_function1, results1)
  }
)

# dataframe -----------------------------------------------------------

test_that(
  desc = "dataframe",
  code = {
    expect_s3_class(
      statsExpressions::expr_anova_bayes(
        data = mtcars,
        x = cyl,
        y = wt,
        output = "dataframe"
      ),
      "tbl_df"
    )
  }
)
