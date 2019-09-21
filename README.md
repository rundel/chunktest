# chunktest

An R package that aides in embedding `testthat` expectations in `knitr` chunks

Just include `chunktest::init()` in your setup chunk and then indicate testthat chunks using testthat for the knitr engine.

For example to include the testtht example tests your Rmd might have the following:

````
```{testthat good}
test_that("one plus one is two", {
  expect_equal(1 + 1, 2)
})

test_that("you can skip tests if needed", {
  skip("This tests hasn't been written yet")
})

test_that("some tests have warnings", {
  expect_equal(log(-1), NaN)
})

test_that("some more successes just to pad things out", {
  expect_true(TRUE)
  expect_false(FALSE)
})
```

```{testthat bad}
plus <- function(x, y) rep(1,length(x)) + rep(1, length(y))

test_that("one plus one is two", {
  expect_equal(plus(1, 1), 2)
})

test_that("two plus two is four", {
  expect_equal(plus(2, 2), 4)
})
```
````

Should knit to something like the following:
``` r
test_that("one plus one is two", {
  expect_equal(1 + 1, 2)
})

test_that("you can skip tests if needed", {
  skip("This tests hasn't been written yet")
})

test_that("some tests have warnings", {
  expect_equal(log(-1), NaN)
})

test_that("some more successes just to pad things out", {
  expect_true(TRUE)
  expect_false(FALSE)
})
```

    ## ══ Results ═════════════════════════════════════════════════════════════════════════════════════════
    ## [ Ok: 4 | Skipped: 1 | Warnings: 1 | Failed: 0 ]

``` r
plus <- function(x, y) rep(1,length(x)) + rep(1, length(y))

test_that("one plus one is two", {
  expect_equal(plus(1, 1), 2)
})

test_that("two plus two is four", {
  expect_equal(plus(2, 2), 4)
})
```

    ## ── 1. Failure: two plus two is four (@unnamed-chunk-1#8)  ──────────────────────────────────────────
    ##   plus(2, 2) not equal to 4.
    ##   1/1 mismatches
    ##   [1] 2 - 4 == -2
    ## 
    ## ══ Results ═════════════════════════════════════════════════════════════════════════════════════════
    ## [ Ok: 1 | Skipped: 0 | Warnings: 0 | Failed: 1 ]


