test_that("nyc_xwalk returns rows for one pair of geographies", {
  result <- nyc_xwalk("cd", "nta")
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
  expect_equal(unique(result$primary_geo_id), "cd")
  expect_equal(unique(result$other_geo_id), "nta")
})

test_that("nyc_xwalk returns all other geographies when to is NULL", {
  result <- nyc_xwalk("pp")
  expect_setequal(
    unique(result$other_geo_id),
    setdiff(nyc_xwalk_geographies_df$geo_id, "pp")
  )
})

test_that("nyc_xwalk accepts several target geographies", {
  result <- nyc_xwalk("cc", c("cd", "nta"))
  expect_setequal(unique(result$other_geo_id), c("cd", "nta"))
})

test_that("nyc_xwalk filters by min_pct and sorts by pct_overlap", {
  result <- nyc_xwalk("nta", "cd", min_pct = 5)
  expect_true(all(result$pct_overlap >= 5))
  first <- result[result$primary_geo_name == result$primary_geo_name[1], ]
  expect_false(is.unsorted(rev(first$pct_overlap)))
})

test_that("nyc_xwalk rejects unknown geographies and bad min_pct", {
  expect_error(nyc_xwalk("zz"))
  expect_error(nyc_xwalk("cd", "zz"))
  expect_error(nyc_xwalk("cd", "nta", min_pct = "a"), "min_pct")
})

test_that("crosswalk shares are consistent with areas", {
  x <- nyc_xwalk_df
  expect_equal(
    x$pct_overlap,
    x$intersection_area_sqft / x$primary_area_sqft * 100
  )
  expect_equal(
    x$pct_of_other,
    x$intersection_area_sqft / x$other_area_sqft * 100
  )
  expect_false(anyNA(x$other_area_sqft))
})

test_that("geographies cover every ID in the crosswalk tables", {
  ids <- nyc_xwalk_geographies_df$geo_id
  expect_length(ids, 15)
  expect_true(all(nyc_xwalk_df$primary_geo_id %in% ids))
  expect_true(all(nyc_xwalk_df$other_geo_id %in% ids))
  expect_setequal(unique(nyc_xwalk_boundaries_sf$geo_id), ids)
  expect_true(all(
    c("primary_geo_id", "primary_geo_name", ids) %in%
      names(nyc_xwalk_wide_df)
  ))
})
