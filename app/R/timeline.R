# Timeline Module for STAND App
# Updated version with:
# - Code legend banner with hover descriptions
# - Russia (red) / West (blue) colors only
# - Updated value boxes

# ==============================================================================
# LIBRARIES
# ==============================================================================

library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(DT)
library(bsicons)
library(bslib)

# ==============================================================================
# CODE DESCRIPTIONS FOR HOVER TOOLTIPS
# ==============================================================================

CODE_DESCRIPTIONS <- list(
  "R1" = "R1: Affirmatory (Nuclear) Deterrence Signaling: Statements or communications by Russian or Belarusian officials that affirm, restate, or reinforce established nuclear deterrence principles, doctrines, or red lines, without introducing new elements or signaling change. In practice, this usually involves quoting the content of the official Russian doctrine that states the conditions under which Moscow would consider authorizing the use of nuclear weapons.",
  
  "R2" = "R2: Active Coercive Nuclear Signaling: Communicative acts in which Russian leaders, officials, or affiliated figures set new conditions and redlines for nuclear weapon use that are more specific than the general Russian nuclear doctrine or even go beyond the doctrine. They are formulated as conditional \"if-then\" or \"unless-then\" statements, where the \"then\" usually stands for \"we will use nuclear weapons,\" \"we will consider nuclear weapons,\" \"we will use all the means available,\" or \"we will be met with unforeseen consequences.\" A good example of the latter is Putin's statement at the onset of the February 2022 invasion: \"Whoever tries to interfere with us, and even more so to create threats for our country, for our people, must know that Russia's response will be immediate and will lead you to consequences that you have never faced in your history.\"",
  
  "R3" = "R3: Tacit Nuclear Signaling: Involves nuclear escalation-related signals that are communicated as actions rather than words. That includes, for example, military exercises with a nuclear component (e.g., Zapad), tests of nuclear or dual-capable launchers, non-routine movements of nuclear or dual-capable launchers, or the demonstrative first use of new dual-capable missiles against military or civilian targets in Ukraine (e.g., we would code the first use of Kinzhal or Oreshnik missiles in Ukraine war as \"tacit nuclear signaling,\" but we would not code a routine use of Iskander missiles as that is no longer perceived as \"nuclear escalation-related\" in the West). In the dataset, we would normally code the description of the action as such (e.g., \"Russia tested new ICBM\") or a neutral, official description of the action (e.g., \"Russian Ministry of Defense issued a statement that Russia had tested a new ICBM\"). Tests and exercises can also be accompanied by additional verbal signals that should be coded separately.",
  
  "R4" = "R4: Anticipatory Policy & Posture Signaling: Teasing/hinting at the possibility of prospective future nuclear policy or posture adjustments, sometimes conditional on Western behavior, external events, domestic dynamics, or other developments. This includes verbal hints that Russia might suspend/withdraw from arms control treaties, revise its nuclear doctrine, resume nuclear testing, engage in nuclear sharing arrangements with allies, and other changes before they were formally adopted.",
  
  "R5" = "R5: Escalatory Policy & Posture Adjustments: Formal modification of nuclear policy framework, strategic posture, or institutional arrangements governing Russian nuclear forces. This includes formally adopted revisions of Russian nuclear doctrine, nuclear sharing arrangements with Belarus, or arms control treaties status changes (e.g., New START suspension).",
  
  "R6" = "R6: Nuclear Escalation Risk Signaling: Communicative acts — usually rhetorical or declarative — that highlight, dramatize, or warn of the risk of uncontrolled nuclear escalation, possibly resulting from Western or Ukrainian actions, without expressing an intent to use nuclear weapons or alter policy. These signals possibly aim to amplify the perceived danger of ongoing conflict dynamics, shape Western threat perception, and encourage restraint through fear of uncontrollable consequences. The category includes, for example, many statements by Maria Zakharova, Dmitry Medvedev, and others, suggesting that Western policy could lead to uncontrollable dynamics and unforeseen consequences. Note that these are not explicit coercive signals in the sense of \"if you do this, we do that;\" rather, these are signals that shape the perceptions of uncontrollable risk, in the logic of Thomas Schelling's \"threat that leaves something to chance.\"",
  
  "R7" = "R7: Blame Deflection: Statements that aim to justify the Russian nuclear escalation-relevant actions or policies (e.g., changes in the Russian nuclear doctrine) by framing them as normatively appropriate/responsible steps responding to inappropriate/irresponsible steps by NATO/Western countries.",
  
  "R8" = "R8: De-escalatory (nuclear) signaling: If R1–R7 are generally issued and/or perceived as \"raising\" or \"maintaining\" nuclear temperature, R8 signals lead to \"lowering\" nuclear temperature in the broader escalation dynamics. Under this logic, Russian officials usually issue statements such as \"nuclear war should never be fought,\" \"we are committed to keeping the conflict non-nuclear,\" \"we want to work with the United States on maintaining strategic stability,\" \"we are open to new arms control talks,\" or \"we will  maintain New START limits despite suspension.\"",
  
  "W1" = "W1: Affirmative (NATO) Deterrence Signaling: Communicative acts in which NATO officials and member states' representatives affirm, restate, or reinforce established NATO deterrence principles, doctrines, or red lines, without introducing new elements or signaling change. The focus of these statements is on the security and territorial integrity of member states rather than Ukraine. As such, the W1 category includes statements such as 'we will defend every inch of NATO territory' or 'any attack on NATO states will be met with a devastating response.'",
  
  "W2" = "W2: Active Deterrence of Nuclear Use: Communicative acts in which Western officials set Russian nuclear weapon use––against Ukraine or elsewhere––as a red line and actively aim at dissuading the Kremlin from doing that. They are formulated as conditional 'if-then' statements, where the 'if' usually stands for 'any use of nuclear weapons' and 'then' usually stands for 'will be met with devastating response' or 'will completely change our approach to this conflict.'",
  
  "W3" = "W3: Tacit Nuclear Signaling: Involves nuclear escalation-related signals that are communicated as actions rather than words. That includes, for example, military exercises with a nuclear component or tests of nuclear or dual-capable launchers.",
  
  "W4" = "W4: Anticipatory Policy & Posture Signaling: Teasing/hinting at the possibility of prospective future policy adjustments that are or can be plausibly perceived by Russia as an escalation. This includes verbal hints that the West might deploy troops to Ukraine, approve deliveries of long-range weapons or aircraft, relax targeting restrictions for its delivered weapons, or adopt new sanctions against Russia. We also include escalatory rhetoric and signals hinting at the need to 'defeat Russia' and similar.",
  
  "W5" = "W5: Escalatory Policy & Posture Adjustments: Formal policy adjustments that have been perceived by Russia as an escalation. This includes deliveries of new types of long-range weapons or aircraft, deliveries of relaxation of targeting restrictions for its delivered weapons, or adoption of new sanctions against Russia.",
  
  "W6" = "W6: Russian Nuclear Policy Assessments: Neutral assessments of the change and continuity in Russian nuclear posture and the probability of nuclear weapon use by Russia. This includes statements such as 'we do not see any changes in Russian nuclear posture' or 'we assess a greater risk of nuclear weapon use' under certain conditions.",
  
  "W7" = "W7: Stigmatizing and Norm-reinforcing Signaling: Communicative acts that shame Russia for not behaving 'responsibly' in the nuclear domain (i.e., portraying Russia as a transgressor of the norms of nuclear order) or verbally reaffirming the validity of the 'nuclear taboo' and other norms of nuclear order (e.g., stating that 'nuclear war cannot be won and must never be fought.'",
  
  "W8" = "W8: De-Escalatory Signaling: Communicative acts that assure Russia that the West might not be implementing policy adjustments that are or can be plausibly perceived by Russia as an escalation. This includes verbal assurance that the West does not plan to deploy troops to Ukraine, approve deliveries of certain sensitive weapons (e.g., Taurus deliveries), or relax targeting restrictions for its delivered weapons. It might also include signals of willingness to 'lower the nuclear temperature,' e.g., to negotiate new arms control agreements or implement steps to reduce nuclear risks."
)

# ==============================================================================
# GLOBAL DATA PREPROCESSING
# ==============================================================================

timeline_data <- read_delim("01_raw_data/RUS-Nthreats-Dataset.csv", delim = ";") |>
  clean_names() |>
  separate_rows(signal, sep = " and ") |>
  separate_rows(date, sep = ", ") |>
  transmute(
    id = signal_number,
    date = dmy(date),
    actor = side,
    actor_label = case_when(
      side == "R" ~ "Russia",
      side == "W" ~ "West",
      .default = side
    ),
    signal = str_trim(signal),
    scale = as.numeric(str_extract(signal, "(?<=[RW])[0-9]")),
    code_label = str_extract(signal, "^[RW][0-9]"),
    signal_type = case_when(
      scale <= 3 ~ "de-escalatory",
      scale <= 6 ~ "warning",
      scale <= 8 ~ "escalatory",
      .default = "warning"
    ),
    scale_diverging = if_else(actor == "R", -scale, scale),
    text = text
  ) |>
  filter(!is.na(date), !is.na(scale)) |> 
  ungroup()

# ==============================================================================
# CONSTANTS
# ==============================================================================

# Colors by actor (Russia = red, West = blue)
ACTOR_COLORS <- c(
  "R" = "#a84247",
  "W" = "#336B91"
)

# ==============================================================================
# MODULE UI
# ==============================================================================

timeline_nav <- function(id) {
  ns <- NS(id)
  
  # Helper to create code badge with tooltip
  create_code_badge <- function(code, color) {
    tags$span(
      class = "code-badge",
      style = paste0(
        "display: inline-block; ",
        "padding: 4px 10px; ",
        "border-radius: 4px; ",
        "background-color: ", color, "; ",
        "color: white; ",
        "font-weight: bold; ",
        "font-size: 0.85em; ",
        "cursor: help; ",
        "min-width: 42px; ",
        "text-align: center;"
      ),
      title = CODE_DESCRIPTIONS[[code]],
      `data-bs-toggle` = "tooltip",
      `data-bs-placement` = "bottom",
      `data-bs-html` = "true",
      code
    )
  }
  
  tagList(
    # JavaScript for Bootstrap tooltips
    tags$head(
      tags$script(HTML("
        $(document).ready(function() {
          $('[data-bs-toggle=\"tooltip\"]').tooltip();
        });
        $(document).on('shiny:connected', function() {
          $('[data-bs-toggle=\"tooltip\"]').tooltip();
        });
      "))
    ),
    
    # Code Legend - single elegant row
    card(
      card_body(
        padding = "0.5rem",
        div(
          style = "display: flex; align-items: center; gap: 20px; flex-wrap: wrap;",
          # Russia codes
          div(
            style = "display: flex; align-items: center; gap: 8px;",
            tags$span(
              style = "font-weight: 600; color: #a84247; font-size: 0.95em;", 
              "Russia:"
            ),
            create_code_badge("R1", "#a84247"),
            create_code_badge("R2", "#a84247"),
            create_code_badge("R3", "#a84247"),
            create_code_badge("R4", "#a84247"),
            create_code_badge("R5", "#a84247"),
            create_code_badge("R6", "#a84247"),
            create_code_badge("R7", "#a84247"),
            create_code_badge("R8", "#a84247")
          ),
          # West codes
          div(
            style = "display: flex; align-items: center; gap: 8px;",
            tags$span(
              style = "font-weight: 600; color: #336B91; font-size: 0.95em;", 
              "West:"
            ),
            create_code_badge("W1", "#336B91"),
            create_code_badge("W2", "#336B91"),
            create_code_badge("W3", "#336B91"),
            create_code_badge("W4", "#336B91"),
            create_code_badge("W5", "#336B91"),
            create_code_badge("W6", "#336B91"),
            create_code_badge("W7", "#336B91"),
            create_code_badge("W8", "#336B91")
          )
        )
      ),
      class = "mb-1"
    ),
    
    # Timeline plot
    card(
      card_header("Nuclear Signaling Timeline"),
      card_body(
        min_height = 400,
        plotlyOutput(ns("timeline_plot"), height = "400px")
      ),
      card_footer(
        class = "d-flex justify-content-between align-items-center",
        tags$p(
          class = "mb-0 text-muted",
          style = "font-size: 1rem;",
          "Please click ",
          tags$a(
            href = "https://www.swp-berlin.org/publications/products/arbeitspapiere/Horovitz_Smetana_et_al-Russia_Nuclear_Signalling_Chronology_Dec25_LARGE.pdf",
            target = "_blank",
            "here"
          ),
          " to access the full publication."
        ),
        actionButton(
          ns("reset_selection"),
          "Reset Selection",
          icon = icon("rotate-left"),
          class = "btn-sm btn-outline-primary"
        )
      ),
      class = "mb-2"
    ),
    
    # Summary statistics - compact horizontal boxes
    card(
      card_body(
        padding = "0.5rem",
        div(
          style = "display: flex; gap: 15px; flex-wrap: nowrap; align-items: stretch;",
          # Total Signals
          div(
            style = "display: flex; align-items: center; gap: 8px; padding: 8px 15px; background-color: var(--bs-dark); color: white; border-radius: 6px; flex: 1; min-width: 0;",
            bs_icon("broadcast", size = "1.5em"),
            div(
              style = "flex: 1;",
              tags$span(style = "font-size: 0.85em; opacity: 0.9;", "Total Signals"),
              tags$br(),
              tags$strong(style = "font-size: 1.3em;", textOutput(ns("total_signals"), inline = TRUE))
            )
          ),
          # Russian Signals
          div(
            style = "display: flex; align-items: center; gap: 8px; padding: 8px 15px; background-color: #a84247; color: white; border-radius: 6px; flex: 1; min-width: 0;",
            bs_icon("flag", size = "1.5em"),
            div(
              style = "flex: 1;",
              tags$span(style = "font-size: 0.85em; opacity: 0.9;", "Russian Signals"),
              tags$br(),
              tags$strong(style = "font-size: 1.3em;", textOutput(ns("russia_count"), inline = TRUE))
            )
          ),
          # Western Signals
          div(
            style = "display: flex; align-items: center; gap: 8px; padding: 8px 15px; background-color: #336B91; color: white; border-radius: 6px; flex: 1; min-width: 0;",
            bs_icon("flag", size = "1.5em"),
            div(
              style = "flex: 1;",
              tags$span(style = "font-size: 0.85em; opacity: 0.9;", "Western Signals"),
              tags$br(),
              tags$strong(style = "font-size: 1.3em;", textOutput(ns("west_count"), inline = TRUE))
            )
          ),
          # De-Escalatory
          div(
            style = "display: flex; align-items: center; gap: 8px; padding: 8px 15px; background-color: #699470; color: white; border-radius: 6px; flex: 1; min-width: 0;",
            bs_icon("arrow-down-circle", size = "1.5em"),
            div(
              style = "flex: 1;",
              tags$span(style = "font-size: 0.85em; opacity: 0.9;", "De-Escalatory (R8/W8)"),
              tags$br(),
              tags$strong(style = "font-size: 1.3em;", uiOutput(ns("deescalatory_count"), inline = TRUE))
            )
          )
        )
      ),
      class = "mb-2"
    ),
    
    # Data table
    card(
      card_header(
        class = "d-flex justify-content-between align-items-center",
        span("Signal Details"),
        uiOutput(ns("selection_badge"))
      ),
      layout_sidebar(
        sidebar = sidebar(
          width = 250,
          tags$h5("About the Data"),
          tags$p(
            "This timeline tracks nuclear-related statements and actions
            during Russia's war against Ukraine."
          ),
          tags$p(
          style = "font-size: 0.9em;",
          tags$b("Data Structure:"), " The counts above reflect unique signals (identified by signal number). 
          However, since a single signal may be coded with multiple categories (e.g., both R1 and R2), 
          the timeline plot and table below display all code instances. This means one signal may appear 
          multiple times with different codes, allowing you to see the full complexity of each event."
          ),
          tags$hr(),
          tags$p(tags$b("Actors:")),
          tags$div(
            style = "font-size: 0.9em;",
            tags$span(style = "color: #a84247; font-weight: bold;", "● "),
            tags$span("Russia (R1-R8)"), tags$br(),
            tags$span(style = "color: #336B91; font-weight: bold;", "● "),
            tags$span("West (W1-W8)")
          ),
          tags$hr(),
          tags$p(
            tags$b("Tip:"), " Hover over code badges above for descriptions. ",
            "Click a point on the timeline to filter the table."
          )
        ),
        DTOutput(ns("signal_table")),
        fillable = FALSE
      ),
      class = "mt-3"
    )
  )
}

# ==============================================================================
# MODULE SERVER
# ==============================================================================

timeline_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # --------------------------------------------------------------------------
    # Reactive: Filtered data based on plotly relayout (date range changes)
    # --------------------------------------------------------------------------
    
    plotly_date_range <- reactiveVal(NULL)
    
    observeEvent(event_data("plotly_relayout", source = ns("timeline")), {
      relayout <- event_data("plotly_relayout", source = ns("timeline"))
      
      if (!is.null(relayout)) {
        # Check if xaxis.range was updated
        if (!is.null(relayout$`xaxis.range[0]`) && !is.null(relayout$`xaxis.range[1]`)) {
          start_date <- as.Date(relayout$`xaxis.range[0]`)
          end_date <- as.Date(relayout$`xaxis.range[1]`)
          plotly_date_range(c(start_date, end_date))
        } else if (!is.null(relayout$`xaxis.range`)) {
          start_date <- as.Date(relayout$`xaxis.range`[[1]])
          end_date <- as.Date(relayout$`xaxis.range`[[2]])
          plotly_date_range(c(start_date, end_date))
        } else if (!is.null(relayout$`xaxis.autorange`) && relayout$`xaxis.autorange` == TRUE) {
          # Reset to show all data
          plotly_date_range(NULL)
        }
      }
    })
    
    filtered_data <- reactive({
      date_range <- plotly_date_range()
      
      if (is.null(date_range)) {
        timeline_data
      } else {
        timeline_data |>
          filter(date >= date_range[1], date <= date_range[2])
      }
    })
    
    # --------------------------------------------------------------------------
    # Reactive: Selected point ID (from click or NULL)
    # --------------------------------------------------------------------------
    
    selected_id <- reactiveVal(NULL)
    
    observeEvent(event_data("plotly_click", source = ns("timeline")), {
      click <- event_data("plotly_click", source = ns("timeline"))
      
      if (!is.null(click)) {
        cd <- click$customdata
        
        clicked_id <- tryCatch({
          if (is.null(cd)) {
            NULL
          } else if (is.list(cd)) {
            as.integer(unlist(cd)[[1]])
          } else if (is.numeric(cd) || is.character(cd)) {
            as.integer(cd[[1]])
          } else {
            NULL
          }
        }, error = function(e) NULL)
        
        if (!is.null(clicked_id) && !is.na(clicked_id)) {
          selected_id(clicked_id)
        }
      }
    }, ignoreNULL = TRUE)
    
    observeEvent(input$reset_selection, {
      selected_id(NULL)
      
      # Reset plotly zoom to show all data
      plotlyProxy(ns("timeline_plot"), session) %>%
        plotlyProxyInvoke("relayout", list("xaxis.autorange" = TRUE))
    })
    
    # --------------------------------------------------------------------------
    # Summary statistics
    # --------------------------------------------------------------------------
    
    output$total_signals <- renderText({
      nrow(filtered_data() |> distinct(id))
    })
    
    output$russia_count <- renderText({
      sum(filtered_data() |> distinct(id, actor) |> pull(actor) == "R")
    })
    
    output$west_count <- renderText({
      sum(filtered_data()|> distinct(id, actor) |> pull(actor)  == "W")
    })
    
    output$deescalatory_count <- renderUI({
      d <- filtered_data() |> distinct(id, actor, scale)
      russia_deesc <- sum(d$actor == "R" & d$scale == 8)
      west_deesc <- sum(d$actor == "W" & d$scale == 8)
      
      paste0(russia_deesc, " Russia / ", west_deesc, " West")
    })
    
    # --------------------------------------------------------------------------
    # Selection badge
    # --------------------------------------------------------------------------
    
    output$selection_badge <- renderUI({
      if (!is.null(selected_id())) {
        span(
          class = "badge bg-info",
          "Filtered to selected point"
        )
      }
    })
    
    # --------------------------------------------------------------------------
    # Helper: Wrap text
    # --------------------------------------------------------------------------
    
    wrap_text <- function(txt, width = 50) {
      vapply(txt, function(t) {
        if (is.na(t) || nchar(t) <= width) return(t)
        words <- strsplit(t, " ")[[1]]
        lines <- character(0)
        current_line <- ""
        for (word in words) {
          test_line <- if (current_line == "") word else paste(current_line, word)
          if (nchar(test_line) <= width) {
            current_line <- test_line
          } else {
            if (current_line != "") lines <- c(lines, current_line)
            current_line <- word
          }
        }
        if (current_line != "") lines <- c(lines, current_line)
        paste(lines, collapse = "<br>")
      }, character(1), USE.NAMES = FALSE)
    }
    
    # --------------------------------------------------------------------------
    # Helper: Prepare plot data
    # --------------------------------------------------------------------------
    
    prepare_plot_data <- function(d) {
      d |>
        mutate(
          text_short = if_else(
            nchar(text) > 200,
            paste0(str_sub(text, 1, 200), "…"),
            text
          ),
          text_wrapped = wrap_text(text_short),
          hover_text = paste0(
            "<b>", format(date, "%d %B %Y"), "</b><br>",
            "<b>Actor:</b> ", actor_label, "<br>",
            "<b>Code:</b> ", code_label, "<br><br>",
            text_wrapped
          ),
          scale_factor = as.character(scale)
        ) |>
        group_by(actor, date, scale_diverging) |>
        mutate(
          n_in_group = n(),
          idx = row_number(),
          y_jittered = scale_diverging + if_else(
            n_in_group == 1L,
            0,
            (idx - (n_in_group + 1) / 2) * 0.2
          )
        ) |>
        ungroup()
    }
    
    # --------------------------------------------------------------------------
    # Timeline plot - uses ALL data (not filtered)
    # --------------------------------------------------------------------------
    
    output$timeline_plot <- renderPlotly({
      d <- timeline_data |>
        arrange(date) |>
        prepare_plot_data()
      
      if (nrow(d) == 0) {
        return(
          plot_ly() |>
            layout(
              title = list(
                text = "No data for selected filters",
                font = list(family = "Source Sans Pro")
              )
            )
        )
      }
      
      russia_data <- filter(d, actor == "R")
      west_data   <- filter(d, actor == "W")
      
      p <- plot_ly(source = ns("timeline")) |>
        add_segments(
          x = min(d$date), xend = max(d$date),
          y = 0, yend = 0,
          line = list(color = "#e0e0e0", width = 1),
          showlegend = FALSE,
          hoverinfo = "none"
        )
      
      # Step lines for Russia
      if (nrow(russia_data) > 0) {
        p <- p |>
          add_lines(
            data = russia_data,
            x = ~date,
            y = ~scale_diverging,
            line = list(shape = "hv", color = ACTOR_COLORS["R"], width = 1.5),
            opacity = 0.4,
            showlegend = FALSE,
            hoverinfo = "none"
          )
      }
      
      # Step lines for West
      if (nrow(west_data) > 0) {
        p <- p |>
          add_lines(
            data = west_data,
            x = ~date,
            y = ~scale_diverging,
            line = list(shape = "hv", color = ACTOR_COLORS["W"], width = 1.5),
            opacity = 0.4,
            showlegend = FALSE,
            hoverinfo = "none"
          )
      }
      
      # Markers by actor (2 colors: Russia = red, West = blue)
      for (actor_code in names(ACTOR_COLORS)) {
        subset_d <- filter(d, actor == actor_code)
        actor_name <- if (actor_code == "R") "Russia" else "West"
        
        if (nrow(subset_d) > 0) {
          p <- p |>
            add_trace(
              data = subset_d,
              x = ~date,
              y = ~y_jittered,
              type = "scatter",
              mode = "markers",
              marker = list(
                size = 11,
                color = ACTOR_COLORS[actor_code],
                opacity = 0.85,
                line = list(color = "white", width = 1)
              ),
              name = actor_name,
              hoverinfo = "text",
              text = ~hover_text,
              customdata = ~id
            )
        }
      }
      
      p |>
        layout(
          font = list(family = "Source Sans Pro"),
          xaxis = list(
            title = "",
            rangeslider = list(
              type = "date",
              thickness = 0.1
            ),
            rangeselector = list(
              buttons = list(
                list(count = 1, label = "1m", step = "month", stepmode = "backward"),
                list(count = 3, label = "3m", step = "month", stepmode = "backward"),
                list(count = 6, label = "6m", step = "month", stepmode = "backward"),
                list(count = 1, label = "1y", step = "year", stepmode = "backward"),
                list(count = 2, label = "2y", step = "year", stepmode = "backward"),
                list(step = "all", label = "All")
              ),
              x = 0,
              xanchor = "left",
              y = 1.15,
              yanchor = "top"
            ),
            range = c("2022-01-01", "2025-01-31")
          ),
          yaxis = list(
            title = "",
            tickvals = c(-8, -4, -1, 1, 4, 8),
            ticktext = c("R8", "R4", "R1", "W1", "W4", "W8"),
            zeroline = FALSE,
            range = c(-9, 9)
          ),
          legend = list(
            orientation = "h",
            xanchor = "center",
            x = 0.5,
            yanchor = "top",
            y = -0.15
          ),
          hovermode = "closest",
          margin = list(l = 50, r = 20, t = 80, b = 50)
        ) |>
        config(
          displayModeBar = FALSE,
          responsive = TRUE,
          scrollZoom = FALSE,
          doubleClick = "reset"
        )
    })
    
    # --------------------------------------------------------------------------
    # Table data
    # --------------------------------------------------------------------------
    
    table_data <- reactive({
      d <- filtered_data()
      sel <- selected_id()
      
      if (is.null(sel)) {
        d
      } else {
        filtered <- filter(d, id == sel)
        if (nrow(filtered) == 0) {
          selected_id(NULL)
          d
        } else {
          filtered
        }
      }
    })
    
    # --------------------------------------------------------------------------
    # Data table
    # --------------------------------------------------------------------------
    
    output$signal_table <- renderDT({
      table_data() |>
        transmute(
          Date = format(date, "%Y-%m-%d"),
          Actor = actor_label,
          Code = code_label,
          Description = text
        ) |>
        datatable(
          style = "bootstrap5",
          extensions = c("Buttons", "Responsive"),
          options = list(
            pageLength = 10,
            scrollX = TRUE,
            order = list(list(0, "desc")),
            dom = "Bfrtip",
            buttons = list(
              list(
                extend = "collection",
                text = "Download",
                className = "btn-primary",
                buttons = list(
                  list(extend = "excel", filename = "nuclear_signals", className = "btn-primary"),
                  list(extend = "csv", filename = "nuclear_signals", className = "btn-primary")
                )
              )
            ),
            language = list(searchPlaceholder = "Search signals..."),
            initComplete = JS(
              "function(settings, json) {
                $(this.api().table().header()).css({
                  'background-color': '#004778',
                  'color': '#fff'
                });
              }"
            )
          ),
          rownames = FALSE,
          class = "cell-border stripe hover",
          escape = FALSE
        )
    })
    
  })
}