library(purrr)
library(cli)

safe_pemob_get_variable <- function(var) {
  # Create a comprehensive error tracking structure
  error_info <- list(
    variable = var,
    error_type = NULL,
    error_message = NULL,
    traceback = NULL
  )

  # Wrap the function with tryCatch for detailed error capture
  result <- tryCatch(
    {
      pemob_get_variable(var)
    },
    error = function(e) {
      # Capture detailed error information
      error_info$error_type <- class(e)[1]
      error_info$error_message <- e$message
      error_info$traceback <- capture.output(traceback())

      # Optionally log the error
      cli_alert_danger("Error processing {.val {var}}:")
      cli_text(e$message)

      # Return the error info structure
      structure(error_info, class = "pemob_error")
    }
  )

  return(result)
}

# Modified processing function
get_full_pemob <- function(keydict) {
  # Process all variables
  results <- map(keydict$x2024, safe_pemob_get_variable)

  # Separate successful and failed results
  successful <- results[!sapply(results, inherits, "pemob_error")]
  errors <- results[sapply(results, inherits, "pemob_error")]

  # Optional: summarize errors
  if (length(errors) > 0) {
    cli_h2("Error Summary")
    error_summary <- map_dfr(errors, function(err) {
      tibble::tibble(
        variable = err$variable,
        error_type = err$error_type,
        error_message = err$error_message
      )
    })

    print(error_summary)
  }

  # Return successful results
  return(successful)
}

# Usage
result <- get_full_pemob(keydict)

# Error analysis
analyze_errors <- function(keydict) {
  all_results <- map(keydict$x2024, safe_pemob_get_variable)

  # Collect error details
  errors <- all_results[sapply(all_results, inherits, "pemob_error")]

  # Create comprehensive error report
  error_report <- map_dfr(errors, function(err) {
    tibble::tibble(
      variable = err$variable,
      error_type = err$error_type,
      error_message = err$error_message,
      traceback = list(err$traceback)
    )
  })

  return(error_report)
}

# Get detailed error report
error_details <- analyze_errors(keydict)

error_details |>
  count(error_message, sort = TRUE)

error_details[1, ]$traceback

unique(error_details$error_message)

pemob_get_variable("3.1.1.C")

missing_columns_2020 <- error_details |>
  filter(error_message == "In index: 5.") |>
  pull(variable)

error_details |>
  filter(error_message == "In index: 1.")
