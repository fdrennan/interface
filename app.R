library(shiny)
library(dplyr)
library(fs)
library(readr)
library(purrr)

withConsoleRedirect <- function(containerId, expr) {
    # Change type="output" to type="message" to catch stderr
    # (messages, warnings, and errors) instead of stdout.
    txt <- capture.output(results <- expr, type = "output")
    if (length(txt) > 0) {
        insertUI(paste0("#", containerId), where = "beforeEnd",
                 ui = paste0(txt, "\n", collapse = "")
        )
    }
    results
}

# Example usage

ui <- fluidPage(
    pre(id = "console")
)

server <- function(input, output, session) {
    observe({
        # invalidateLater(5000)

        withConsoleRedirect("console", {
            {
                print('Library Paths')
                print(.libPaths())
                print('Packages Installed')

                installed.packages() %>%
                    as_tibble() %>%
                    select(Package, Version) %>%
                    as.data.frame %>%
                    print

                map(
                    dir_ls('files_to_print/'),
                    function(x) {
                        print(read_file(x))
                    }
                )
            }
        })
    })
}

shinyApp(ui, server)
