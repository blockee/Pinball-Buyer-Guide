shinyUI(fluidPage(
    titlePanel("Pinball Buyer's Guide"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Whether you're looking for a great value on a machine to buy or just want to find a new table you'd
                     like to play, this guide will help you find a table based on your tastes. Use the sliders below to
                     assign a weight to each category of your table ranking score. The site will use that to generate
                     a score for each of the available tables and to determine how much bang for your buck each table
                     represents."),
            
            sliderInput('rating',
                    label = 'Player Ratings',
                    value = 1, min = 0, max = 5, step = .25),
            
            sliderInput('game',
                    label = 'Game Design',
                    value = 1, min = 0, max = 5, step = .25),
            
            sliderInput('art',
                         label = 'Art',
                        value = 1, min = 0, max = 5, step = .25),
            
            
            sliderInput('sound',
                    label = 'Sound',
                    value = 1, min = 0, max = 5, step = .25),
            
            sliderInput('other',
                         label = 'Other Game Aspects',
                        value = 1, min = 0, max = 5, step = .25),
            
            sliderInput('staff',
                         label = 'Pinside Staff Ratings',
                        value = 1, min = 0, max = 5, step = .25),
            
            helpText("Excluding the production year in the pricing model will likely push older tables
                     to the top of the bargain rankings. If you'd prefer a newer machine, leave this checked."
                ),
            
            checkboxInput('year',
                         label = 'Include Machine Year in Price Model?',
                         value = TRUE),
            
            submitButton('Submit')
            
            ),
    
        
        mainPanel(
            tabsetPanel(
                tabPanel("Main",
                    br(),
                    textOutput('topTableExplainer'),
                    br(),
                    dataTableOutput('topTables'),
                    br()
                    
                ),
                tabPanel("About This App", 
                         tags$body(textOutput('summary')),
                         br()
                )
            )
        )
    )
))