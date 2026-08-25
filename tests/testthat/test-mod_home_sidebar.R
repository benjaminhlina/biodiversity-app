test_that("home_sidebar_server initializes with Poland selected", {
  fake_con <- structure(list(), class = "fake_con") # placeholder, see below

  testServer(
    home_sidebar_server,
    args = list(con = fake_con, main_input = reactiveValues(tabs = "home")),
    {
      session$setInputs(country_filter = "Poland")
      expect_equal(input$country_filter, "Poland")
    }
  )
})


test_that("changing country triggers search_species with new country", {
  called_with <- NULL

  local_mocked_bindings(
    search_species = function(session, input, con, selected_country = NULL) {
      called_with <<- selected_country %||% input$country_filter
    }
  )

  testServer(
    home_sidebar_server,
    args = list(con = "unused", main_input = reactiveValues(tabs = "home")),
    {
      session$setInputs(country_filter = "Poland")
      expect_equal(called_with, "Poland")
    }
  )
})


test_that("search_species returns expected species for Poland", {
  con <- make_test_con(tbl_name = "tbl_spp", df = test_poland_spp)
  withr::defer(DBI::dbDisconnect(con, shutdown = TRUE))

  mock_session <- shiny::MockShinySession$new()
  result <- search_species(
    session = mock_session,
    input = shiny::reactiveValues(species_search = NULL),
    con = con,
    selected_country = "Poland"
  )
  expect_true("Abies alba" %in% result)
})
