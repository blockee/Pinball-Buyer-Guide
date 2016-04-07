library(shiny)
library(DT)
pinData <- read.csv('pinDataMassaged.csv', header=TRUE)

userTable <- data.frame()

shinyServer(function(input, output){
    
    getUserFrame <- reactive({
        userScore <- pinData$rating * input$rating + pinData$gameDesign * input$game + pinData$artwork * input$art +
            pinData$sound * input$sound + pinData$otherRating  * input$other + pinData$staffRating * input$staff
        
        userTable <- data.frame()
        userTable <- data.frame(pinData, userScore)
        
        if (input$year == 'TRUE'){
                userModel <- lm(avgValue ~ userScore + age, data = userTable)
        }   else{
                userModel <- lm(avgValue ~ userScore, data = userTable)
        }
        
        pricePredict <- predict(userModel, userTable)
        
        pinBargain <- round(pricePredict - userTable$avgValue)
        
        userTable <- data.frame(userTable, pinBargain)
        
        userTable <- userTable[,c('nameLink', 'makeAndYear', 'userScore', 'estimatedValue', 'pinBargain')]
    })
    
    output$topTables <- DT::renderDataTable({
        
        DT::datatable(data = getUserFrame(),
                    colnames = c('Name', 'Make & Year', 'Your Score', 'Market Price', 'Bargain Amount($)'), 
                    escape = 0, rownames = FALSE, 
                    options = list(pageLength = 20, order = list(2,'desc')))
    })
    
    
    
    output$topTableExplainer <- renderText({
        "The following table presents the top-scoring games based on your criteria. The Bargain Amount column is how much
        of a value buy this game represents when compared to a pricing model based on your criteria. The higher the better. 
        Negative numbers represent games that are overpriced according to the pricing model. 
        Click on the Bargain Amount column to sort by best value. These tables would
        be a great, low-cost way to start your collection."
    })
    
    
    output$summary <- renderText({
        "   This app was born after I read way too many 'What should I buy?' discussions on pinball forums. I figured that people
        would appreciate the ability to find great tables based on what they consider most important in a game. As someone longing
        to buy his first pinball machine, I also knew that people would be looking for value tables that they could get a lot of
        game time out of. The data comes from the Pinside top ~250 tables. Some had to be excluded because pricing information
        wasn't available."
    })    
      
    output$explanation <- renderText({
        "   That's how it all got started. The analysis treats your rank for the week as a given and then randomly assigns
        you a win or a loss with the odds of each outcome being determined by your scoring rank and the number of possible 
        opponents. Think of if as pulling a random opponent out of a hat and assigning you a win or loss based on
        the comparison between your opponent's scoring rank and yours."  
    })
    
    output$assumptions <- renderText({
        "This model assumes that you didn't have any way to play defense and prevent your opponent from scoring 
        (a very safe assumption given the rules of FF) and also assumes that you didn't adjust your roster based
        on your weekly opponent. This may not always be the case. You may have played a high variance (boom/bust) player
        in hopes of making up a (projected) defecit. That being said, most fantasy managers play what they believe to be
        their best weekly lineup regardless of their opponent. If your team was unlucky this year, I hope you still managed
        to sneak into the playoffs and that regression to the mean is the wind behind your back on the way to the 'ship!"
    })

    


}
)