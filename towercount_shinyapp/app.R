# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)
library(shinythemes)
library(shinyWidgets)

#Import Data
tower <- read_csv("Data/towerclean.csv", 
                                col_types = cols(date = col_date(format = "%Y-%m-%d")))
#Format year column
tower$year <- year(as.Date(as.character(tower$year), format = "%Y"))

tower <- tower %>%
  mutate(label = case_when(species == "herg" ~ "Herring Gulls",
                         species == "gbbg" ~ "Great Black-backed Gull",
                         species == "blgu" ~ "Black Guillemot",
                         species == "coei_ad" ~ "Common Eider (Adults)",
                         species == "coei_ju" ~ "Common Eider (Chicks)",
                         species == "comu" ~ "Common Murre",
                         species == "razo" ~ "Razorbill",
                         species == "noga" ~ "Northern Gannet",
                         species == "puffin" ~ "Atlantic Puffin",
                         species == "peepsp" ~ "Peep sp.",
                         species == "ternsp" ~ "Tern sp.",
                         species == "baea" ~ "Bald Eagle",
                         species == "colo" ~ "Common Loon",
                         species == "lagu" ~ "Laughing Gull",
                         species == "cago" ~ "Canada Goose",
                         species == "shearwater" ~ "Shearwater sp.",
                         species == "wisp" ~ "Wilson's Storm-petrel",
                         species == "raptor" ~ "Raptor sp.",
                         species == "gbhe" ~ "Heron sp.",
                         species == "dcco" ~ "Double-Crested Cormorant",
                         species == "lbbg" ~ "Lesser Black-backed Gull",
                         species == "scoter" ~ "Scoter sp.",
                         TRUE ~ as.character(species)))

#make lists of years and species
yearlist <- as.list(unique(tower$year))
specieslist <- as.list(unique(tower$species))
labellist <- as.list(unique(tower$label))


tower$date[tower$date == "2008-05-28"] <- "2018-05-28"

#define standard error function
se <- function(x) sd(x)/sqrt(length(x))


#########################################################
###################### U I ##############################
#########################################################

ui <- fluidPage(theme = shinytheme("superhero"),
  titlePanel("Tower Count Data"),
  sidebarLayout(
    sidebarPanel(
        pickerInput("yearIn", "Year:", choices = yearlist, options = list(`actions-box` = TRUE),multiple = TRUE, selected = c(2000:2022)),
        selectInput("plottype","Plot Type", choices = c("barplot","boxplot","multi-year barplot","lines", "multi-year boxplots","counts within season", "lines faceted by species", "boxplots faceted by species"), selected = "lines faceted by species"),
        selectInput("barstat","Statistic to Use (won't affect boxplots)", choices = c("Median", "Mean", "High Count", "Season Total"), selected = "Median"),
        checkboxGroupInput("speciesIn", "Species", choiceValues = specieslist, selected  = c("herg","gbbg","coei_ad","blgu"), choiceNames = labellist)
    ),
    mainPanel(
      plotOutput("plot"),
      textOutput("text"),
    )
   )
)

#########################################################
###################### SERVER ###########################
#########################################################

server <- function(input, output) {
  output$text <- renderText({
    if (input$plottype %in% c("counts within season","lines faceted by species", "boxplots faceted by species")){
      print("NOTE: When this warning is shown, X and Y axes are not consistent between plots.")
    }
  })
  output$plot <- renderPlot({
     if (input$plottype == "barplot") {
        tower %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        group_by(species, year) %>% 
        summarize(se = se(count), stat = if (input$barstat == "Median") {
         median(count)
        } else if (input$barstat == "High Count") {
         max(count)
        } else if (input$barstat == "Mean") {
         mean(count)
        } else if (input$barstat == "Season Total") {
         sum(count)
        }) %>%
        ggplot(aes(x = species, y = stat, fill = species))+
        geom_col()+
        geom_errorbar(aes(x = species, ymin = (stat - se), ymax = (stat + se)), alpha = 
                        (if(input$barstat %in% c("Median", "Mean")){0.8} else {0}), size = 0.9, width = 0.3)+
        facet_wrap(~year)+
        labs(title = paste(input$barstat, "counts by species and year"), subtitle = "Great Duck Tower Data", caption = "Error bars represent standard error")+
        scale_fill_viridis_d()+
        theme_bw()
     } else if (input$plottype == "boxplot") {
        tower %>% 
        group_by(species, year) %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        ggplot(aes(x = species, y = count, fill = species))+
        geom_boxplot()+
        facet_wrap(~year)+
        labs(title= "Counts by species and year", subtitle = "Great Duck Tower Data")+
        scale_fill_viridis_d()+
        theme_bw()
    } else if (input$plottype == "multi-year barplot") {
        tower %>% 
        mutate(year = as.character(year)) %>% 
        group_by(species, year) %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        summarize(se = se(count), stat = if (input$barstat == "Median") {
          median(count)
        } else if (input$barstat == "High Count") {
          max(count)
        } else if (input$barstat == "Mean") {
          mean(count)
        } else if (input$barstat == "Season Total") {
          sum(count)
        }) %>% 
        ggplot(aes(x = year, y = stat, fill = species))+
        geom_col(position = position_dodge(preserve = "single"), width = 0.75)+
        geom_errorbar(aes(x = year, ymin = (stat - se), ymax = (stat + se), group = species), alpha = 
                        (if(input$barstat %in% c("Median", "Mean")){0.8
                        } else {0}),
                        size = 0.9, width = 0.3, position = position_dodge(width = 0.75, preserve = "single"))+
        labs(title= paste(input$barstat, "counts by species and year"), subtitle = "Great Duck Tower Data", caption = "error bars represent standard error")+
        scale_fill_viridis_d()+
        theme_bw()
    } else if (input$plottype == "lines") {
        tower %>% 
        group_by(species, year) %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        summarize(se = se(count),stat = if (input$barstat == "Median") {
          median(count)
        } else if (input$barstat == "High Count") {
          max(count)
        } else if (input$barstat == "Mean") {
          mean(count)
        } else if (input$barstat == "Season Total") {
          sum(count)
        }) %>% 
        ggplot()+
        geom_point(aes(x = year, y = stat, color = species), size = 2)+
        geom_errorbar(aes(x = year, ymin = (stat - se), ymax = (stat + se)), alpha = 
                        (if(input$barstat %in% c("Median", "Mean")){0.8}
                         else {0}), size = 0.5, width = 0.005)+
        geom_line(aes(x = year, y = stat, color = species), linewidth = 1.3 )+
        labs(title = paste(input$barstat, "counts by species and year"), subtitle = "Great Duck Tower Data", caption = "Error Bars Represent Standard Error")+
        scale_color_viridis_d()+
        theme_bw()
    } else if (input$plottype == "multi-year boxplots") {
      tower %>% 
        group_by(species, year) %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        mutate(year = as.factor(year)) %>% 
        ggplot(aes(x = year, y = count, fill = species, color = species))+
        geom_boxplot(color = "black")+
        labs(title= "Species Counts by Year", subtitle = "Great Duck Tower Data")+
        scale_fill_viridis_d(alpha = 0.8)+
        scale_color_viridis_d()+
        theme_bw()
    } else if (input$plottype == "counts within season") {
      tower %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        mutate(year = as.factor(year)) %>% 
        ggplot(aes(x = date, y = count, fill = species))+
        geom_col(position = "dodge")+
        labs(title= "Counts throughout season", subtitle = "Great Duck Tower Data")+
        scale_fill_viridis_d() +
        facet_wrap(~year, scales = "free")+
        theme_bw()
    } else if (input$plottype == "lines faceted by species") {
      tower %>% 
        group_by(species, year) %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        summarize(se = se(count), stat =
          if (input$barstat == "Median") {
          median(count)
        } else if (input$barstat == "High Count") {
          max(count)
        } else if (input$barstat == "Mean") {
          mean(count)
        } else if (input$barstat == "Season Total") {
          sum(count)
        }) %>% 
        ggplot()+
        geom_point(aes(x = year, y = stat, color = species), size = 2)+
        geom_errorbar(aes(x = year, ymin = (stat - se), ymax = (stat + se)), alpha = 
                        (if(input$barstat %in% c("Median", "Mean")){0.8}
                         else {0}), size = 0.5, width = 0.005)+
        geom_line(aes(x = year, y = stat, color = species), linewidth = 1.3 )+
        facet_wrap(~species, scales = "free")+
        labs(title = paste(input$barstat, "counts by species and year"), subtitle = "Great Duck Tower Data", caption = "error bars represent standard error")+
        scale_color_viridis_d()+
        theme_bw()
    } else if (input$plottype == "boxplots faceted by species") {
      tower %>% 
        group_by(species, year) %>% 
        filter(year %in% input$yearIn) %>% 
        filter(species %in% input$speciesIn) %>% 
        mutate(year = as.factor(year)) %>% 
        ggplot(aes(x = year, y = count, fill = species, color = species))+
        geom_boxplot(color = "black")+
        labs(title= "Species Counts by Year", subtitle = "Great Duck Tower Data")+
        scale_fill_viridis_d(alpha = 0.8)+
        scale_color_viridis_d()+
        facet_wrap(~species, scales = "free") +
        theme_bw()
    }
})
 
}

# Run the application 
shinyApp(ui = ui, server = server)