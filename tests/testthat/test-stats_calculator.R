test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


test_that("Strength and toughness dynamics", {
  expect_equal(get_strength_toughness_prob(4,4) , 4)
})



test_that("Hitting is working",{
  expect_equal(get_prob_hit(3), 2/3)
})

test_that("Wounding is working",{
  expect_equal(get_prob_wound(6,3), 5/6)
})


test_that("Saving is working",{
  expect_equal(get_prob_save(2), 1/6)
})


test_that("Kill count does work",{
  expect_equal(get_kill_count(11,2,3), 5)
})

