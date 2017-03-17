
##7. Repeat with diabetes data! 
Preprocess the "PimaIndiansDiabetes2" data
```{r}
# load the dataset
data(PimaIndiansDiabetes2)
?PimaIndiansDiabetes2
data <- PimaIndiansDiabetes2 # give the data a simpler name
str(data)
```

Check for missing data:
  ```{r}
# check for missing cases
sum(is.na(data)) 

# how much of the data is missing? 
sum(is.na(data)) / (nrow(data)*ncol(data)) # about 9% 
```

Use Chris K's handy median impute function to impute missing values: 
```{r}
# impute and add missingness indicators
result = ck37r::impute_missing_values(data) 

# overwrite "data" with new imputed data frame
data <- result$data 
```

Double check that missing values have been imputed:
```{r}
# no more NA values
sum(is.na(data))

# check that missingness indicators have been added
str(data)

# expand our one factor (diabetes) out into indicators
data <- data.frame(model.matrix( ~ ., subset(data)))
str(data)

# remove the unnecessary intercept column
data <- data[,-1]
str(data)
```

Parse our data into our Y outcome variable and X predictor variables and training and test sets:
```{r, eval=FALSE}
# define Y
#pressure <- "pressure" # for Y and X assignment purposes
#Y <- data$pressure # for modeling purposes

# define X predictors
#X <- data[, !names(data) == pressure]

# double check that the "pressure" vector has been removed
#str(X)

# expand our one factor (diabetes) out into indicators
data <- data.frame(model.matrix( ~ ., subset(data)))
str(data)

# remove the unnecessary intercept column
data <- data[,-1]
str(data)

## split data
set.seed(1)

# Create a stratified random split
split <- createDataPartition(data$pressure, p=0.70, list=FALSE) 

train <- data[split, ] # partition training dataset
test <- data[-split, ] # partition test dataset

#Y_train <- Y[split] # partition training Y variable vector
#Y_test <- Y[-split] #  partition test Y variable vector

```

##8. Simple linear regression (diabetes)
```{r}
lin_mod1 <- lm(pressure ~ glucose, data=train)
lin_mod1
summary(lin_mod1)

plot(pressure ~ glucose, data=train, col="gray80",
xlim=c(0,300), ylim=c(0,200))
abline(lin_mod1$coefficients[1], lin_mod1$coefficients[2], col="black", lwd=2)
legend("topleft", inset=.0, c("linear"), lty=1, lwd=2, col="black", cex=.75)
```

##9. Polynomial (3rd degree)
```{r}
## the "poly" function produces the same results
plot(y=train$pressure, x=train$glucose)
lin_mod_poly2 <- lm(train$pressure ~ poly(train$glucose, 3, raw=TRUE))
lin_mod_poly2
summary(lin_mod_poly2)
points(train$glucose ~ fitted(lin_mod_poly2), lty=2, lwd=2, col="red", data=train)
#lines(glucose ~ fitted(lin_mod_poly2), lty=2, lwd=2, col="red", data=train)
legend("topleft", inset=.0, c("linear", "poly 3"), lty=c(1,2), lwd=2, col=c("black","red"), cex=.75)

```
