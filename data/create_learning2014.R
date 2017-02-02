#Herman Savinen
#26.1.2017
#Data wrangling excercise

library(dplyr)

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header=T)

dim(learning2014) # Data has 183 observations of 60 variables
str(learning2014) # Names and data types of variables

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$Deep <- rowMeans(deep_columns)

surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$Surf <- rowMeans(surface_columns)

strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$Stra <- rowMeans(strategic_columns)

learning2014$Attitude <- learning2014$Attitude / 10


keep_columns <- c("gender","Age","Attitude", "Deep", "Stra", "Surf", "Points")
analysis_learning2014 <- select(learning2014,one_of(keep_columns))

analysis_learning2014 <- filter(analysis_learning2014, Points != 0)

setwd("C:/Users/Admin/Documents/GitHub/IODS-project/data")

write.csv(analysis_learning2014, file = "learning2014.csv", row.names=FALSE)

d <- read.csv("learning2014.csv")
str(d)
head(d)

