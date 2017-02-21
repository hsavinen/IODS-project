library(dplyr)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd)
str(gii)

summary(hd)
summary(gii)

hd <- rename(hd, hdi_rank = HDI.Rank, hdi = Human.Development.Index..HDI., life_expectancy = Life.Expectancy.at.Birth, edu_expected = Expected.Years.of.Education, edu_mean = Mean.Years.of.Education, gni = Gross.National.Income..GNI..per.Capita, gni_rank_minus_hdi_rank = GNI.per.Capita.Rank.Minus.HDI.Rank, country = Country)

gii <- rename(gii, adol_birthrate = Adolescent.Birth.Rate ,gii_rank = GII.Rank, country = Country, gii = Gender.Inequality.Index..GII., maternal_mortality =  Maternal.Mortality.Ratio, repres_parliament = Percent.Representation.in.Parliament, second_edu_F = Population.with.Secondary.Education..Female., second_edu_M = Population.with.Secondary.Education..Male., labour_particip_F = Labour.Force.Participation.Rate..Female., labour_particip_M = Labour.Force.Participation.Rate..Male.)

gii <- mutate(gii, "edu2F/edu2M" = second_edu_F / second_edu_M)
gii <- mutate(gii, "labF/labM" = labour_particip_F / labour_particip_M)

human <- inner_join(hd, gii, by = "country")

setwd("C:/Users/Admin/Documents/GitHub/IODS-project/data")

write.csv(human, file = "human.csv", row.names=FALSE)

library(stringr)

human <- mutate(human, GNI = str_replace(gni, pattern=",", replace ="") %>% as.numeric)

keep <- c("country", "second_edu_F", "labour_particip_F", "life_expectancy", "edu_expected", "GNI", "maternal_mortality", "adol_birthrate", "repres_parliament")
human <- select(human, one_of(keep))

human <- filter(human, complete.cases(human))

last <- nrow(human) - 7
human_ <- human[1:last, ]

rownames(human_) <- human_$country

human_ <- select(human_, -country)


write.csv(human_, file = "human.csv", row.names=TRUE)
