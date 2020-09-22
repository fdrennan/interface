library(shiny)
library(dplyr)
library(fs)
library(readr)
library(purrr)

#' withConsoleRedirect
renv::install('fdrennan/ndexrstrator', rebuild = TRUE)
library(ndexie)

# Example usage

ui <- fluidPage(
    textInput('text_1',
              'TEXT INPUT',
              value = "0",
              width = '100%',
              placeholder = 'An input of Text'),
    actionButton(inputId = "do", label =  "Click Me", width = '100%'),
    pre(id = "console")
)

server <- function(input, output, session) {
    observe({
        # invalidateLater(5000)
        observeEvent(input$do, {
            withConsoleRedirect("console", {
                {
                    cat('\n------------------------------------\n')
                    current_number <- as.numeric(input$text_1)
                    if (current_number == 0) {
                        cat('0: Options\n1. System\n2. Directory')
                    }

                    if (current_number == 1) {
                        response <- system('ls -lah', intern = TRUE)
                        print(response)
                        response <- system('df -h', intern = TRUE)
                        print(response)
                    }

                    if (current_number == 2) {
                        response <- fs::dir_ls(recurse = TRUE, all = TRUE)
                        print(response)
                    }
                    cat('\n\n')
                }
            }, where = "afterBegin")
        })

    })
}

shinyApp(ui, server)
