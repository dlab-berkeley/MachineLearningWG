install.packages("devtools")
devtools::install_github(c("ecpolley/SuperLearner", "ck37/ck37r"))
ck37r::load_packages(c("rpart", "rpart.plot", "partykit", "mlr", "caret",
                       "h2o"), auto_install = TRUE)