




timeline_docu <- list(
  tags$p(tags$b("Signal Classification"), br(),
         "Nuclear signals are classified according to their escalation level:"),
  tags$ul(
    tags$li(tags$b("Escalatory:"), " Implicit or explicit threats of nuclear use"),
    tags$li(tags$b("Warning:"), " Allusions to nuclear capabilities without direct threat"),
    tags$li(tags$b("De-escalatory:"), " Statements retracting or questioning previous escalatory signals")
  ),
  tags$p(tags$b("Actors"), br(),
         "R = Russia, W = West (primarily nuclear-weapon states and NATO officials)"),
  tags$p(tags$b("Scale"), br(),
         "Higher absolute values indicate more escalatory rhetoric."),
  tags$p("Additional information can be found under the Documentation section.")
)




doku_nav <- function(id, label = "doku") {
  ns <- NS(id)
  tagList(fluidPage(
                    fluidRow(
                      column(9,
                             card(
                               includeHTML(rmarkdown::render("www/documentation/documentation.Rmd")),
                               style = "margin-top: 20px;"
                             )),
                      column(
                        3,
                        card(
                          card_header("Contact:"),
                          card_body(
                            tags$li(
                              tags$a("Liviu Horovitz", href = "https://www.swp-berlin.org/wissenschaftler-in/liviu-horovitz"),
                              "Lead Researcher"
                            )
                          ),
                          style = "margin-top: 20px;"
                        ),
                        div(  
                          class = "sticky-top",  
                          style = "top: 20px;", 
                          card(
                            includeMarkdown(
                              "www/documentation/toc.md"
                            ),
                            style = "margin-top: 20px;",
                          )
                        )
                      )
                    )))
}

