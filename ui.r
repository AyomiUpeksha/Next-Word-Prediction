
suppressWarnings(library(shiny))
shinyUI(fluidPage("",
                   tabPanel("Predicting the next word",
                            HTML("<strong>Author: A.U</strong>"),
                            br(),
                            HTML("<strong>Date: 2020/08/25</strong>"),
                            br(),
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                textInput("inputString", "Enter phrase here",value = ""),
                                br(),
                                br(),
                                br(),
                                br(),
                                submitButton("Enter")
                              ),
                              mainPanel(
                                #h2("Next word"),
                                #textOutput("prediction")
                              tabsetPanel(type = "tabs",
                                          tabPanel("About",br(),HTML("<strong>Description</strong>"),
                                          br(),br(),
                                          "This application is deeloped as part of the requirment for the 
                                          coursera Data Science Capston Project.",br(),
                                          "This predictive model will be trained using a corpus, a collection
                                          of written text called corpora which has been filtered language.",br(),
                                          "The app takes as input a phrase in a text box inputs and outputs a
                                          prediction of the next word",br(),br(),br(),
                                          HTML("<strong>Step</strong>"),br(),br(),
                                          "Type the word phrase which you wish to obtain next word. Go the APP",
                                          HTML("<strong>Click Enter!</strong>"),
                                          "Then you can be obtained the next word"),
                                          tabPanel("App",br(),
                                                   h2("Next word"),textOutput("prediction")))
                              )
                            )
                            
                   )
)
)