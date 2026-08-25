test_that("create_base_data retrieves and collects database data correctly", {
  con <- make_test_con(tbl_name = "tbl_occ", df = test_poland_occ)
  # on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

  # Test server logic
  shiny::testServer(
    app = function(input, output, session) {
      input_source <- shiny::reactive(list(
        country_filter = "Poland",
        species_filter = "Acanthosoma haemorrhoidale"
      ))
      base_data <- create_base_data(con = con, input_source = input_source)
    },
    expr = {
      df <- base_data()
      expect_s3_class(df, "data.frame")
      expect_equal(nrow(df), 3)
      expect_true(all(df$country == "Poland"))
      expect_true(all(df$scientific_name %in% "Acanthosoma haemorrhoidale"))
    }
  )
})

test_that("create_base_data returns NULL when all countries are selected", {
  con <- make_test_con(tbl_name = "tbl_occ", df = test_poland_occ)
  # on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

  shiny::testServer(
    app = function(input, output, session) {
      input_source <- shiny::reactive(list(
        country_filter = "",
        species_filter = "All"
      ))

      base_data <- create_base_data(con = con, input_source = input_source)
    },
    expr = {
      expect_null(base_data())
    }
  )
})

test_that("create_filtered_data filters correctly by date_range", {
  con <- make_test_con(tbl_name = "tbl_occ", df = test_poland_occ)
  # on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

  shiny::testServer(
    app = function(input, output, session) {
      # Pass reactive data as base_data
      input_source <- shiny::reactive(list(
        country_filter = "Poland",
        species_filter = "All"
      ))
      base_data <- create_base_data(con = con, input_source = input_source)
      # Create filtered data using session input
      filtered_data <- create_filtered_data(data = base_data, input = input)

      # Simulate user updating date range slider in Shiny
      session$setInputs(
        date_range = as.POSIXct(c(
          "2017-06-30 08:03:00",
          "2019-04-23 10:24:00"
        ))
      )
    },
    expr = {
      df_filtered <- filtered_data()

      expect_equal(nrow(df_filtered), 6)
      expect_equal(
        df_filtered$id,
        c(
          "161827036@OBS",
          "157461072@OBS",
          "157474169@OBS",
          "159676137@OBS",
          "170864085@OBS"
        )
      )
    }
  )
})
