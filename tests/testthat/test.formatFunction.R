# MixtComp version 4 - july 2019
# Copyright (C) Inria - Université de Lille - CNRS

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>


# @author Quentin Grimonprez
context("Format functions")

test_that("createFunctional works with void element", {
  time <- NULL
  data <- NULL
  expectedOut <- ""

  out <- createFunctional(time, data)
  expect_equal(out, expectedOut)

  time <- c()
  data <- c()
  expectedOut <- ""

  out <- createFunctional(time, data)
  expect_equal(out, expectedOut)
})

test_that("createFunctional works with vectors of different size", {
  time <- c(1, 2, 3, 4, 5)
  data <- c(1.2, 3.33, 8.99, 7.87, 14.58, 16, 45)
  expectedOut <- "1:1.2,2:3.33,3:8.99,4:7.87,5:14.58"

  expect_warning(out <- createFunctional(time, data))
  expect_equal(out, expectedOut)
})

test_that("createFunctional remove NA", {
  time <- c(1, 2, NA, 4, 5)
  data <- c(NA, 3.33, 8.99, 7.87, 14.58, 16, 45)
  expectedOut <- "2:3.33,4:7.87,5:14.58"

  expect_warning(out <- createFunctional(time, data))
  expect_equal(out, expectedOut)
})


test_that("createFunctional works", {
  time <- c(1)
  data <- c(42)
  expectedOut <- "1:42"

  out <- createFunctional(time, data)
  expect_equal(out, expectedOut)


  time <- c(1, 2)
  data <- c(3.33, 8.99)
  expectedOut <- "1:3.33,2:8.99"

  expect_warning(out <- createFunctional(time, data), regexp = NA)
  expect_equal(out, expectedOut)
})

test_that("convertFunctionalToVector works with a void string", {
  chaine <- ""
  expectedOut <- list(time = c(), value = c())

  out <- convertFunctionalToVector(chaine)
  expect_equal(out, expectedOut)


  chaine <- NA

  out <- convertFunctionalToVector(chaine)
  expect_equal(out, expectedOut)


  chaine <- NULL

  out <- convertFunctionalToVector(chaine)
  expect_equal(out, expectedOut)
})

test_that("convertFunctionalToVector works", {
  chaine <- "1:42"
  expectedOut <- list(time = 1, value = 42)

  out <- convertFunctionalToVector(chaine)
  expect_equal(out, expectedOut)

  chaine <- "1:42,2:43,3:44,4:46,5:87,6:100"
  expectedOut <- list(time = c(1, 2, 3, 4, 5, 6), value = c(42, 43, 44, 46, 87, 100))

  out <- convertFunctionalToVector(chaine)
  expect_equal(out, expectedOut)
})


test_that("refactorCategorical works when oldCateg and newCateg do not have common elements", {
  x <- letters
  oldCateg <- letters
  newCateg <- seq_along(oldCateg)

  expectedOut <- newCateg

  out <- refactorCategorical(x, oldCateg, newCateg)
  expect_equal(out, expectedOut)
})

test_that("refactorCategorical works when oldCateg and newCateg have common elements", {
  x <- as.character(0:10)
  oldCateg <- as.character(0:10)
  newCateg <- 1:11

  expectedOut <- newCateg

  out <- refactorCategorical(x, oldCateg, newCateg)
  expect_equal(out, expectedOut)
})

test_that("refactorCategorical works when some categories are merged", {
  x <- letters[1:6]
  oldCateg <- letters[1:6]
  newCateg <- rep(c("voyelle", "consonne", "voyelle", "consonne"), c(1, 3, 1, 1))
  expectedOut <- newCateg

  out <- refactorCategorical(x, oldCateg, newCateg)

  expect_equal(out, expectedOut)
})

test_that("refactorCategorical works when there are categories not included in the data", {
  x <- letters[1:6]
  oldCateg <- letters[1:7]
  newCateg <- rep(c("voyelle", "consonne", "voyelle", "consonne"), c(1, 3, 1, 2))

  expectedOut <- newCateg[1:6]

  expect_warning(out <- refactorCategorical(x, oldCateg, newCateg), regexp = NA)
  expect_equal(out, expectedOut)


  x <- letters[1:7]
  oldCateg <- letters[1:6]
  newCateg <- rep(c("voyelle", "consonne", "voyelle", "consonne"), c(1, 3, 1, 1))

  expectedOut <- c(newCateg[1:6], NA)

  expect_warning(out <- refactorCategorical(x, oldCateg, newCateg))
  expect_equal(out, expectedOut)
})


test_that("refactorCategorical kept NA values in data", {
  x <- c(letters[1:6], NA)
  oldCateg <- letters[1:6]
  newCateg <- rep(c("voyelle", "consonne", "voyelle", "consonne"), c(1, 3, 1, 1))
  expectedOut <- c(newCateg[1:6], NA)

  expect_warning(out <- refactorCategorical(x, oldCateg, newCateg), regexp = NA)
  expect_equal(out, expectedOut)
})
