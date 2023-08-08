library(DBI)

con <- dbConnect(RPostgres::Postgres(),dbname = 'postgres', 
                 host = "localhost", 
                 port = 5432, 
                 user = 'postgres',
                 password ='mypassword')

bankstotal <- dbSendQuery(con, 
                        "SELECT id, asset, security 
FROM banks_total;")

bankstotal <- as.data.frame(dbFetch(bankstotal))
write.csv(bankstotal, "C:\\Users\\Public\\banks_total.csv", row.names=FALSE)

length(bankstotal$id)
