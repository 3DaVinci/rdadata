# save_dadata_tokens()  ----
test_that("save_dadata_tokens(): Does not return output",{
  expect_true(save_dadata_tokens("test"))
  expect_true(save_dadata_tokens(api_token = "test", secret_token = "test"))
  expect_error(save_dadata_tokens(api_token = NULL, secret_token = NULL))
})

# get_dadata_tokens()  ----
test_that("get_dadata_tokens(): Does not have any param",{
  expect_error(get_dadata_tokens("test"))
  expect_s3_class(get_dadata_tokens(), class = "data.frame")
})

# supported_suggestions() ----
test_that("supported_suggestions(): Field vector equal & and is.vector",{
  expect_equal(supported_suggestions(), c(
    "address", "postal_unit","country","party","bank","fio","fms_unit","email",
    "fns_unit","fts_unit", "region_court","metro","car_brand","mktu",
    "okved2","okpd2","oktmo","currency","find_affiliated"))
  expect_error(supported_suggestions("test"))
})

# supported_find_by_id() ----
test_that("supported_find_by_id(): Field vector equal & and is.vector",{
  expect_equal(supported_find_by_id(),     c(
    "postal_unit","country","fns_unit","fts_unit","region_court","car_brand","mktu",
    "okved2","party","okpd2","oktmo","currency","address",
    "delivery","fias","bank","cadastre"))
  expect_error(supported_find_by_id("test"))
})

# supported_cleans() ----
test_that("supported_cleans(): Field vector equal & and is.vector",{
  expect_equal(supported_cleans(),     c("address","geocode","name","phone",
                                         "passport","email","clean"))
  expect_error(supported_cleans("test"))
})

# suggest() ----
test_that("suggest(): ",{
  expect_error(suggest("test"))
  expect_error(suggest(method = "bank", query = "ти"))
})

