# between-subjects design -----------------------------------------------

test_that(
  desc = "expr_t_nonparametric works - between-subjects design",
  code = {
    skip_if(getRversion() < "3.6")

    # ggstatsplot output
    set.seed(123)
    using_function <-
      statsExpressions::expr_t_nonparametric(
        data = mtcars,
        x = am,
        y = wt,
        k = 3,
        conf.level = 0.90
      )

    # expected output
    set.seed(123)
    results <-
      ggplot2::expr(
        paste(
          "log"["e"](italic("W")["Mann-Whitney"]),
          " = ",
          "5.440",
          ", ",
          italic("p"),
          " = ",
          "4.35e-05",
          ", ",
          widehat(italic("r")),
          " = ",
          "0.727",
          ", CI"["90%"],
          " [",
          "0.608",
          ", ",
          "0.873",
          "]",
          ", ",
          italic("n")["obs"],
          " = ",
          "32"
        )
      )

    # testing overall everything identical
    expect_identical(using_function, results)
  }
)

# within-subjects design -----------------------------------------------

test_that(
  desc = "expr_t_nonparametric works - within-subjects design",
  code = {
    skip_if(getRversion() < "3.6")

    # made up data
    Input <- ("
              Bird   Typical  Odd
              A     -0.255   -0.324
              B     -0.213   -0.185
              C     -0.190   -0.299
              D     -0.185   -0.144
              E     -0.045   -0.027
              F     -0.025   -0.039
              G     -0.015   -0.264
              H      0.003   -0.077
              I      0.015   -0.017
              J      0.020   -0.169
              K      0.023   -0.096
              L      0.040   -0.330
              M      0.040   -0.346
              N      0.050   -0.191
              O      0.055   -0.128
              P      0.058   -0.182
              ")

    # creating a dataframe
    df_bird <- read.table(textConnection(Input), header = TRUE)

    # converting to long format
    df_bird %<>%
      as_tibble(x = .) %>%
      tidyr::gather(
        data = .,
        key = "type",
        value = "length",
        Typical:Odd
      )

    # expect error
    expect_error(suppressWarnings(statsExpressions::expr_t_nonparametric(
      data = iris,
      x = Sepal.Length,
      y = Species
    )))

    # ggstatsplot output
    set.seed(123)
    using_function2 <-
      suppressWarnings(statsExpressions::expr_t_nonparametric(
        data = df_bird,
        x = type,
        y = length,
        k = 5,
        nboot = 25,
        conf.type = "perc",
        conf.level = 0.99,
        paired = TRUE
      ))

    # expected output
    set.seed(123)
    results2 <-
      ggplot2::expr(
        paste(
          "log"["e"](italic("V")["Wilcoxon"]),
          " = ",
          "2.30259",
          ", ",
          italic("p"),
          " = ",
          "0.00295",
          ", ",
          widehat(italic("r")),
          " = ",
          "-0.75000",
          ", CI"["99%"],
          " [",
          "-0.88250",
          ", ",
          "-0.59500",
          "]",
          ", ",
          italic("n")["pairs"],
          " = ",
          "16"
        )
      )

    # testing overall call
    expect_identical(using_function2, results2)
  }
)


# dataframe -----------------------------------------------------------

test_that(
  desc = "dataframe",
  code = {
    expect_s3_class(
      statsExpressions::expr_t_nonparametric(
        data = dplyr::filter(movies_long, genre == "Action" | genre == "Drama"),
        x = "genre",
        y = rating,
        output = "dataframe"
      ),
      "tbl_df"
    )
  }
)


# works with subject id ------------------------------------------------------

test_that(
  desc = "works with subject id",
  code = {
    skip_if(getRversion() < "3.6")

    # data
    df <-
      structure(list(
        score = c(
          70, 82.5, 97.5, 100, 52.5, 62.5,
          92.5, 70, 90, 92.5, 90, 75, 60, 90, 85, 67.5, 90, 72.5, 45, 60,
          72.5, 80, 100, 100, 97.5, 95, 65, 87.5, 90, 62.5, 100, 100, 97.5,
          100, 97.5, 95, 82.5, 82.5, 40, 92.5, 85, 72.5, 35, 27.5, 82.5
        ), condition = structure(c(
          5L, 1L, 2L, 3L, 4L, 4L, 5L, 1L,
          2L, 3L, 2L, 3L, 3L, 4L, 2L, 1L, 5L, 5L, 4L, 1L, 1L, 4L, 3L, 5L,
          2L, 5L, 1L, 2L, 3L, 4L, 4L, 5L, 1L, 2L, 3L, 2L, 3L, 4L, 1L, 5L,
          3L, 2L, 5L, 4L, 1L
        ), .Label = c("1", "2", "3", "4", "5"), class = "factor"),
        id = structure(c(
          1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L,
          2L, 3L, 3L, 4L, 3L, 4L, 3L, 4L, 3L, 4L, 4L, 5L, 5L, 5L, 5L,
          5L, 6L, 6L, 6L, 6L, 6L, 7L, 7L, 7L, 7L, 7L, 8L, 8L, 8L, 8L,
          8L, 9L, 9L, 9L, 9L, 9L
        ), .Label = c(
          "1", "2", "3", "4", "5",
          "6", "7", "8", "9"
        ), class = "factor")
      ), row.names = c(
        NA,
        45L
      ), class = "data.frame")

    df <- dplyr::filter(df, condition %in% c(1, 5))

    # incorrect
    set.seed(123)
    expr1 <-
      statsExpressions::expr_t_nonparametric(
        data = df,
        x = condition,
        y = score,
        subject.id = id,
        paired = TRUE
      )

    # correct
    set.seed(123)
    expr2 <-
      statsExpressions::expr_t_nonparametric(
        data = dplyr::arrange(df, id),
        x = condition,
        y = score,
        paired = TRUE
      )

    expect_equal(expr1, expr2)
  }
)
