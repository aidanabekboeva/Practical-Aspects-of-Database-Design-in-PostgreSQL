library(quantmod)
library(tidyverse)


###################################  Question 2  ##############################

#1) Download daily stock data

stocks <- "NFLX"
getSymbols(stocks, from="2021-12-01", to = "2022-12-01")

#2) Get the adjusted close

adjPrice <- NFLX$NFLX.Adjusted

#3) Perform a rolling window estimation

size = 2
n_windows = nrow(adjPrice) - 2
results <- c()

for(i in 1:n_windows){
  
  subs <- adjPrice[i:(i+1), ]
  
  mean[i] <- mean(subs)
  sdv[i] <- sd(subs)
}

#4) Plot this statistical dataframe using scatter plot. 

results <- data.frame(mean, sdv)

results <- setNames(cbind(rownames(results), results, row.names = NULL), 
         c("Index", "Mean", "SD"))

library(ggplot2)

colors <- c("Mean" = "red", "Standard Deviation" = "blue")

ggplot() +  
  geom_line(aes(x=results$Index, y=results$Mean, group = 1, color = "Mean")) +    
  geom_line(aes(x=results$Index, y=results$SD, group = 2, color = "Standard Deviation")) +   
  ylab('Values')+xlab('date')

#5) Return the statistical dataframe

summary(results)

#6) Test your function with suitable parameters

stocks <- "AAPL"
getSymbols(stocks, from="2020-12-01", to = "2022-12-01")

adjPrice <- AAPL$AAPL.Adjusted

size = 20
n_windows = nrow(adjPrice) - 2
results <- c()

for(i in 1:n_windows){
  
  subs <- adjPrice[i:(i+1), ]
  
  mean[i] <- mean(subs)
  sdv[i] <- sd(subs)
}
results <- data.frame(mean, sdv)

results <- setNames(cbind(rownames(results), results, row.names = NULL), 
                    c("Index", "Mean", "SD"))
tail(results)


###################################  Question 3  ##############################

library(DBI)

#1) Make a connection to your local PostgreSQL database

con <- dbConnect(RPostgres::Postgres(),dbname = 'postgres', 
                 host = "localhost", 
                 port = 5432, 
                 user = 'postgres',
                 password ='221928ABb')

#2) Query the PostgreSQL databa

bank_data <- dbSendQuery(con, 
                          "SELECT id, date, asset, liability, idx  
FROM bank_data;")

bank_data <- as.data.frame(dbFetch(bank_data))

#3) Calculate asset growth rate

asset_growth <- c()

for(i in 2:37819){
  if (bank_data$id[i] == bank_data$id[i-1]) {
    gr = (bank_data[i, 3] - bank_data[i-1, 3])/bank_data[i-1, 3]
    asset_growth <- append(asset_growth, gr)
  } else asset_growth <- append(asset_growth, NA)
}
asset_growth

bank_data$asset_growth[2:37819] <- asset_growth


#4) Export the dataframe of Q 3.3 to the PostgreSQL database via API.

dbWriteTable(con, "bank_data_new", bank_data, overwrite = T)
