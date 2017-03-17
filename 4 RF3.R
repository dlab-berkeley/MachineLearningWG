#
#
# Day 1 Review
# object definition
#1 name
#2 assignment operator (<-)
#3 definition

# 3 atomic data types
#1 character/string/text
#2 integer/numeric
#3 logical/boolean

# factor data types

# 4 data structures
# concatenate a vector?
?c
# concatenate a list?
?list
# concatenate a matrix?
?matrix
# concatenate a data frame?
?data.frame

#library(swirl)
#swirl()

#
#
# Day 2 Review

# set our working directory

# 1D subsetting
?"$"

# 2D subsetting
?"["
# missing data
NA

# recoding data

# merge, cbind, rbind


# Day 3

# p < 0.05
# this is called a "95% CI"

# might have a p-value of
p < 0.10

or 

p < 0.0000000000000001


# load the animals data frame
# where am I? 
getwd()

# where do I want to go?
setwd("/Users/evanmuzzall/Desktop/R-Fundamentals/data")
getwd()

# check contents of WD?
ls()
dir()

# object definition
# how to load .csv file?
animals <- read.csv("animals.csv", header=TRUE, stringsAsFactors = TRUE)
str(animals)

# summarization!

#1 
?summary
summary(animals)
summary(animals$Weight)

install.packages("psych")

# 
library(psych)
?describe

describe(animals[,3:5])




x <- describe(animals[,-c(1,2)])


x2 <- x[,c(3,4,13)]
x2

# how to save to your WD?
write.csv(x2 , "/Users/evanmuzzall/Desktop/x2.csv" , row.names=TRUE)

###
?describeBy
x3 <- describeBy(animals[,c(3,4,5)], animals$Type)
x3

x3$Cat[,c("mean", "se")]

# 
?table
table(animals$Type)

# one way 
z <- table(animals$Type, animals$Healthy)
prop.table(z)

# another way 
prop.table(table(animals$Type, animals$Healthy))

###
### Challenge 1 
1. load the 'mtcars' dataset
2. Use summary, describe(By), and table to tell me something about cars!
  
data(mtcars) # load mtcars data
str(mtcars)
?mtcars

summary(mtcars)

describe(mtcars)

table(mtcars)
table(mtcars$carb)
rownames(mtcars)


# create a histogram
?hist 
?png

jpeg("histogram.jpeg", height=6, width=6, units="in", res=600) # this tells your computer to initialize a .png file called "histogram.png"

hist(animals$Weight, # select one vector/variable/column
     col="purple", # add a color to the bars
     main="Histogram of animal weight", # change title
     xlab="Weight (kg)", # change the x axis label
     ylab="FREQUENCY!!!!", # change the y axis label
     las=1)

dev.off() # this writes the file


# see pre-built colors
colors()
palette()


# scatterplots?
?plot

animals$Weight
animals$Height

png("scatterplot.png", height=6, width=6, units="in", res=600) # this tells your
plot(x = animals$Weight, y = animals$Height,
     main="This is a scatterplot",
     xlab="Weight (kg)",
     ylab="Height (cm)",
     col=as.numeric(animals$Type), # map color to Type vector
     cex=2, # change point size
     #xlim=c(min(animals$Weight), max(animals$Weight)), # set the limits of x axis
     #ylim=c(min(animals$Height), max(animals$Height))) # set the limits of y axis
     xlim=c(2,10),
     ylim=c(4,11),
     pch=as.numeric(animals$Type),
     las=1)
legend("topright", inset=.0, title="Animal",
       cex=1,
       c("Cat", "Dog", "Pig"), 
       col=c(1,2,3),
       pch=c(1,2,3),
       horiz=FALSE)
dev.off()


## the ggplot2 way
install.packages("ggplot2")
library(ggplot2)
ggplot(animals, aes(x=Weight, y=Height, col=Type, size=4)) +
  geom_point() + 
  theme_classic() + 
  ggtitle("This is ggtitle") +
  xlab("Weight (kilograms)") +
  ylab("Height (meters)") +
  theme(plot.title = element_text(hjust = 1.5)) + 
  scale_size(guide="none") # As of Mar 2012


## boxplots
?boxplot
boxplot(animals$Height ~ animals$Type, las=1,
        col=c("goldenrod", "turquoise", "salmon"))

## the ggplot2 way
gg_box <- ggplot(animals, aes(x=Type, y=Height)) + 
  geom_boxplot(fill=c("gray", "blue", "green")) #+

gg_box
  #scale_fill_manual(breaks=("green", "blue", "red")
ggsave("boxplots.pdf")
??ggplot2

### challenge 2
# 1. Subset two datasets from animals:
#  - one called "dogs" that contains only dogs
#  - one called "cats" that contains only cats

dogs <- animals[animals$Type == "Dog",]

cats <- animals[animals$Type == "Cat",]

dogs
cats
  
### statistical testing 
### t-test - compares ONE or TWO group means!
?t.test
t.test(dogs$Height, cats$Height)
summary(dogs$Height)
summary(cats$Height)

### analysis of variance (ANOVA)- compares TWO OR MORE group means!
### a Tukey HSD test is a common "post hoc" test
?aov

aov1 <- aov(Height ~ Type, data=animals)
aov1
summary(aov1)

TukeyHSD(aov1)

### correlation
### Pearson's r
?cor.test
cor.test(animals$Height, animals$Weight)


### linear regression
?lm
?glm

mod1 <- lm(Height ~ Weight, data=animals)
mod1 # print coefficients (intercept and slope)

# view summary output
summary(mod1)
hist(mod1$residuals)

#Challenge 7
#Using the mtcars dataset, create boxplots for one numeric variable as parsed by a factor variable.
gg_mpg <- ggplot(mtcars, aes(x=as.factor(cyl), y=mpg)) + 
  geom_boxplot()
gg_mpg


#How do you load the “mtcars” dataset?
#How do you view the variable names of this dataset?
#Might you surmise a relationship about something like engine size and miles per gallon?
cor.test(mtcars$mpg, mtcars$cyl)


#What does cor.test reveal about engine size and miles per gallon?
#Create a scatterplot of two variables using plot().
ggplot(mtcars, aes(x=as.factor(cyl), y=mpg, col=cyl)) + 
  geom_point()


#Can one of these variables be used to predict another in a linear regression model?

mtcars_mod <- lm(mpg ~ cyl, data=mtcars)
summary(mtcars_mod)
# "unlikedly that no relationship exists" = "there IS a relationship"

