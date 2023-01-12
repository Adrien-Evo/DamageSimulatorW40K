test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


test_that("Strength and toughness dynamics", {
  expect_equal(get_strength_toughness_prob(4,4) , 4)
})

