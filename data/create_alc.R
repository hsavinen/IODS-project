# Herman Savinen
# 7.2.2017
# Data wrangling excercise week 3 
# Data source: https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

library(dplyr)

math <- read.table("C:/Users/Admin/Documents/GitHub/IODS-project/data/student-mat.csv", sep = ";", header = TRUE)
por <- read.table("C:/Users/Admin/Documents/GitHub/IODS-project/data/student-por.csv", sep = ";", header = TRUE)

str(math)
str(por)

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))
str(math_por)

alc <- select(math_por, one_of(join_by))

notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- select(two_columns, 1)[[1]]
  }
}

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

setwd("C:/Users/Admin/Documents/GitHub/IODS-project/data")

write.csv(alc, file = "alc.csv", row.names=FALSE)


