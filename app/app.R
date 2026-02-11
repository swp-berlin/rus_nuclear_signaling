# Define UI
# 
# 

ui <-
  navbarPage(
    title = "Russia's Nuclear Signaling in the War Against Ukraine",
    header = tagList(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
      )),
    theme = bs_theme(
      version = 5,
      fg = "#040404", 
      primary = "#004778", 
      secondary = "#875e00", 
      success = "#699470", 
      danger = "#a84247", 
      base_font = font_google("Source Sans Pro"), 
      heading_font = font_google("Source Sans Pro"), 
      font_scale = NULL, 
      spacer = "2rem", 
      bootswatch = "minty", 
      bg = "#FFFFFF",
      info = "#99B5C7",
      "pagination-disabled-bg" = "#99B5C7",
      "pagination-hover-bg" = "#99B5C7",
      
      # Customize navbar
      "navbar-bg" = "#004778", 
      "navbar-light-color" = "#fff",
      "navbar-light-hover-color" = "#cdac62",
      "navbar-light-active-color" = "#cdac62",
      "navbar-padding-y" = "1rem",  # control vertical padding
      "navbar-padding-x" = "1rem",  # control horizontal padding
      "navbar-brand-color" =  "#fff",  # control brand font size
      "navbar-brand-font-size" = "1.4rem",  # slightly smaller for longer title
      "navbar-brand-padding-y" = ".5rem",  # control brand vertical padding
      "navbar-toggler-padding-y" = ".25rem",  # control toggler vertical padding
      "navbar-toggler-padding-x" = ".75rem",  # control toggler horizontal padding
      "navbar-toggler-font-size" = "1.25rem",  # control toggler font size
    ), 
    

    nav_panel(title = "Timeline",
              timeline_nav("timeline")),
    
    nav_panel(title = "About",
        doku_nav("doku_module")),

    collapsible = TRUE,
    fillable = FALSE
  )

# Define server logic 
server <- function(input, output,session) {

  timeline_server("timeline")
  
}

# Run the application 
shinyApp(ui = ui, server = server)
