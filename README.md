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
test_that("one plus one is two", {
  expect_equal(plus(1, 1), 2)
})

test_that("two plus two is four", {
  expect_equal(plus(1:2, 1:2), c(2,4))
  expect_equal(plus(2:3, 2:3), c(4,6))
  expect_equal(plus(4, 4), 8)
  expect_equal(plus(5, 5), 10)
})

test_that("two plus two is four", {
  expect_equal(plus(2, 2), 4)
})

test_that("two plus two is four", {
  expect_equal(plus(2, 2), 4)
})

test_that("two plus two is four", {
  expect_equal(plus(2, 2), 4)
})

test_that("two plus two is four", {
  expect_equal(plus(2, 2), 4)
})
```
````
