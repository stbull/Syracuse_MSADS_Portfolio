#Samuel Bull IST 687 Final Project Code




# Hints 1-3 #
base <- "~/Desktop/airsurvey.json"
airsurvey <- read_json(base, simplifyVector = TRUE)
col <- length(airsurvey)
rows <- length(airsurvey[[1]])
ColName <- names(airsurvey)
airData <- data.frame(matrix(unlist(airsurvey), ncol = col, nrow = rows), stringsAsFactors = FALSE)
colnames(airData) <- ColName


airData$Age <- as.numeric(airData$Age)
airData$Flights.Per.Year <- as.numeric(airData$Flights.Per.Year)
airData$Loyalty <- as.numeric(airData$Loyalty)
airData$Total.Freq.Flyer.Accts <- as.numeric(airData$Total.Freq.Flyer.Accts)
airData$Shopping.Amount.at.Airport <- as.numeric(airData$Shopping.Amount.at.Airport)
airData$Eating.and.Drinking.at.Airport <- as.numeric(airData$Eating.and.Drinking.at.Airport)
airData$Total.Money.Spent <- airData$Shopping.Amount.at.Airport + airData$Eating.and.Drinking.at.Airport
airData$Day.of.Month <- as.numeric(airData$Day.of.Month)
airData$Scheduled.Departure.Hour <- as.numeric(airData$Scheduled.Departure.Hour)
airData$Departure.Delay.in.Minutes <- as.numeric(airData$Departure.Delay.in.Minutes)
airData$Arrival.Delay.in.Minutes <- as.numeric(airData$Arrival.Delay.in.Minutes)
airData$Arival.Delay.More.than.5 <- ifelse(airData$Arrival.Delay.in.Minutes > 5, "Yes","No")
airData$Flight.time.in.minutes <- as.numeric(airData$Flight.time.in.minutes)
airData$Flight.Distance <- as.numeric(airData$Flight.Distance)
airData$Likelihood.to.recommend <- as.numeric(airData$Likelihood.to.recommend)
airData$Detractor <- ifelse(airData$Likelihood.to.recommend < 7, "Yes", "No")
airData$olat <- as.numeric(airData$olat)
airData$olong <- as.numeric(airData$olong)
airData$dlong <- as.numeric(airData$dlong)
airData$dlat <- as.numeric(airData$dlat)
airData$Gender <- factor(airData$Gender, ordered = TRUE, levels = c("Male","Female"))
airData$Price.Sensitivity <- factor(airData$Price.Sensitivity, ordered = TRUE, levels = c(0,1,2,3,4,5))
airData$Airline.Status <- factor(airData$Airline.Status, ordered = TRUE, levels = c("Platinum","Gold","Silver","Blue"))
airData$Type.of.Travel <- factor(airData$Type.of.Travel, ordered = TRUE, levels = c("Business travel","Mileage tickets","Personal Travel"))
airData$Class <- factor(airData$Class, ordered = TRUE, levels = c("Business","Eco Plus","Eco"))
airData$Detractor <- factor(airData$Detractor, ordered = TRUE, levels= c("Yes","No"))
airData$Arival.Delay.More.than.5 <- factor(airData$Arival.Delay.More.than.5, ordered = TRUE, levels= c("Yes","No"))

airData$Flight.Delay.in.Total <- airData$Departure.Delay.in.Minutes + airData$Arrival.Delay.in.Minutes
airData$Long.Trip.Duration <- ifelse(airData$Flight.Delay.in.Total > 93, "True", "False")
airData$Long.Trip.Duration <- factor(airData$Long.Trip.Duration, ordered = TRUE, levels= c("True","False"))

airData$NPS.Category <- npc(airData$Likelihood.to.recommend, breaks= list
                            (0:6,7:8,9:10))

NAdf <- airData[rowSums(is.na(airData))>0,]
cancelled <- airData[airData$Flight.cancelled == "Yes",]
airData <- na.omit(airData)


# Hint 4a #
ggplot(airData, aes(Age)) + geom_histogram(binwidth = 5, color="black",fill="white") + ggtitle("Basic Age Histogram")
ggplot(airData,aes(x=factor(0),Age)) + geom_boxplot() + coord_flip() + ggtitle("Basic Age Boxplot")
ggplot(airData, aes(Flights.Per.Year)) + geom_histogram(binwidth = 5, color="black",fill="white") + ggtitle("Basic Flights per Year Histogram")
ggplot(airData,aes(x=factor(0),Flights.Per.Year)) + geom_boxplot() + coord_flip() + ggtitle("Basic Flights per Year Boxplot")
ggplot(airData, aes(Loyalty)) + geom_histogram(binwidth = .5, color="black",fill="white")  + ggtitle("Basic Loyalty Histogram")
ggplot(airData,aes(x=factor(0),Loyalty)) + geom_boxplot() +coord_flip() + ggtitle("Basic Loyalty Boxplot")
ggplot(airData, aes(Flight.Delay.in.Total)) + geom_histogram(binwidth = 10, color="black",fill="white") + ggtitle("Basic Total Delay Histogram")
ggplot(airData,aes(x=factor(0),Flight.Delay.in.Total)) + geom_boxplot() + coord_flip() + ggtitle("Basic Total Delay Boxplot")
ggplot(airData, aes(Total.Money.Spent)) + geom_histogram(binwidth = 50, color="black",fill="white") + ggtitle("Basic Spending Histogram")
ggplot(airData,aes(x=factor(0), Total.Money.Spent)) + geom_boxplot() + coord_flip() + ggtitle("Basic Spending Boxplot")

#Hint 4b#
table(airData$Gender)
table(airData$Type.of.Travel)
table(airData$Price.Sensitivity)
table(airData$Origin.State)
table(airData$Airline.Status)
table(airData$Class)
table(airData$Partner.Name)

# Hint 4c #
ggplot(airData, aes(x=Gender, y=Likelihood.to.recommend)) + geom_boxplot() + ggtitle("Gender/Recommendation Boxplot")
ggplot(airData, aes(x=Price.Sensitivity, y=Likelihood.to.recommend)) + geom_boxplot() + ggtitle("Price Sensitivity/Recommendation Boxplot")
ggplot(airData, aes(x=Type.of.Travel, y=Likelihood.to.recommend)) + geom_boxplot() + ggtitle("Type of Travel/Recommendation Boxplot")
ggplot(airData, aes(x=Class, y=Likelihood.to.recommend)) + geom_boxplot() + ggtitle("Class/Recommendation Boxplot")
ggplot(airData, aes(x=Airline.Status, y=Likelihood.to.recommend)) + geom_boxplot() + ggtitle("Airline Status/Recommendation Boxplot")

# Hint 4d#
airData %>%
   group_by(Gender) %>%
   summarize(nps=nps(Likelihood.to.recommend, breaks = list(0:6,7:8,9:10))) %>%
   ggplot(aes(x=Gender,y=nps)) +geom_col()+ ggtitle("Gender NPS")
airData %>%
   group_by(Type.of.Travel) %>%
   summarize(nps=nps(Likelihood.to.recommend, breaks = list(0:6,7:8,9:10))) %>%
   ggplot(aes(x=Type.of.Travel,y=nps)) +geom_col() + ggtitle("Travel Type NPS")
airData %>%
   group_by(Class) %>%
   summarize(nps=nps(Likelihood.to.recommend, breaks = list(0:6,7:8,9:10))) %>%
   ggplot(aes(x=Class,y=nps)) +geom_col() + ggtitle("Flight Class NPS")
airData %>%
   group_by(Airline.Status) %>%
   summarize(nps=nps(Likelihood.to.recommend, breaks = list(0:6,7:8,9:10))) %>%
   ggplot(aes(x=Airline.Status,y=nps)) +geom_col() + ggtitle("Airline Status NPS")
airData %>%
   group_by(Price.Sensitivity) %>%
   summarize(nps=nps(Likelihood.to.recommend, breaks = list(0:6,7:8,9:10))) %>%
   ggplot(aes(x=Price.Sensitivity,y=nps)) +geom_col() + ggtitle("Price Sensitivity NPS")


# Hint 6#
airDataMap <- airData[!airData$Origin.State == "Alaska",]
airDataMap <- airDataMap[!airDataMap$Origin.State=="Hawaii",]
airDataMap <- airDataMap[!airDataMap$Origin.State=="Puerto Rico",]
us <- map_data("state")
dummy <- data.frame(state.name, stringsAsFactors = FALSE)
dummy$state <- tolower(dummy$state.name)
USmap <- ggplot(dummy, aes(map_id = state)) + geom_map(map = us, color="black", fill="white") +expand_limits(x=us$long, y=us$lat) + coord_map()

StateMean <- tapply(airDataMap$Likelihood.to.recommend, airDataMap$Origin.State, mean)
OriginStateNames <- names(StateMean)
airDataMap$StateMean <- 0
for (x in 1:46) {
  indexes <- which(OriginStateNames[x] == airDataMap$Origin.State)
  airDataMap$StateMean[indexes] <- StateMean[x]
}
airDataMap$state <- tolower(airDataMap$Origin.State)
AvgStateMap <- ggplot(airDataMap, aes(map_id=state)) + geom_map(map=us, aes(fill=StateMean)) +expand_limits(x=us$long, y=us$lat) +ggtitle("Average Recommendation by Origin State")

CityMean <- tapply(airDataMap$Likelihood.to.recommend, airDataMap$Orgin.City, mean)
OriginCityNames <- names(CityMean)
airDataMap$CityMean <-0
for (x in 1:170) {
    indexes <- which(OriginCityNames[x] == airDataMap$Orgin.City)
    airDataMap$CityMean[indexes] <- CityMean[x]
}
airDataMap$CityMeanBreakdown <- cut(airDataMap$CityMean,breaks = c(1,2,3,4,5,6,7,8,9,10), labels = c("1-1.9","2-2.9","3-3.9","4-4.9","5-5.9","6-6.9","7-7.9","8-8.9","9-10"))
airDataMap$sizes <- factor(airDataMap$CityMeanBreakdown, levels = c("1-1.9","2-2.9","3-3.9","4-4.9","5-5.9","6-6.9","7-7.9","8-8.9","9-10"))
CityColors <- brewer.pal(9,"Reds")
names(CityColors) <- levels(airDataMap$sizes)
StateandCity <- AvgStateMap + geom_point(data = airDataMap, aes(x=airDataMap$olong, y=airDataMap$olat, color = sizes)) + scale_color_manual(name="Average per Origin City", values = CityColors) + ggtitle("Average Likelihood to Recommend by Origin State and City")


#Hint7#
promoters <- airDataMap[airDataMap$Likelihood.to.recommend>8,]
promoters$CityMeanBreakdown <- cut(promoters$CityMean,breaks = c(8,9,10), labels = c("8-8.9","9-10"))
promoters$sizes <- factor(promoters$CityMeanBreakdown, levels = c("8-8.9","9-10"))
ProCityColors <- brewer.pal(3,"Reds")
names(ProCityColors) <- levels(promoters$sizes)
USmap + geom_point(data = promoters, aes(x=promoters$olong, y=promoters$olat, color = sizes)) + scale_color_manual(name="Average per Origin City", values = CityColors) + ggtitle("Promoters by Origin City")

detractors <- airDataMap[airDataMap$Likelihood.to.recommend<7,]
detractors$CityMeanBreakdown <- cut(detractors$CityMean,breaks = c(1,2,3,4,5,6,7), labels = c("1-1.9","2-2.9","3-3.9","4-4.9","5-5.9","6-6.9"))
detractors$sizes <- factor(detractors$CityMeanBreakdown, levels = c("1-1.9","2-2.9","3-3.9","4-4.9","5-5.9","6-6.9"))
DetCityColors <- brewer.pal(6,"Reds")
names(DetCityColors) <- levels(detractors$sizes)
USmap + geom_point(data = detractors, aes(x=detractors$olong, y=detractors$olat, color = sizes)) + scale_color_manual(name="Average per Origin City", values = CityColors) + ggtitle("Detractors by Origin City")


#Hint 8#
airDataX <- as(airData, "transactions")
itemFrequency(airDataX)
rules <- apriori(airDataX, parameter = list(support=0.1, confidence=.5), appearance = list(rhs=c("Detractor=Yes")))

#Hint9#
lm1 <- lm(formula = Likelihood.to.recommend~Age, data = airData)
lm2 <- lm(formula = Likelihood.to.recommend~Flight.Delay.in.Total, data = airData)
lm3 <- lm(formula = Likelihood.to.recommend~Flight.Distance, data = airData)
lm4 <- lm(formula = Likelihood.to.recommend~Flight.time.in.minutes, data = airData)
lm5 <- lm(formula = Likelihood.to.recommend~Gender, data = airData)
lm6 <- lm(formula = Likelihood.to.recommend~Price.Sensitivity, data = airData)
lm7 <- lm(formula = Likelihood.to.recommend~Type.of.Travel, data = airData)
lm8 <- lm(formula = Likelihood.to.recommend~Class, data = airData)
lm9 <- lm(formula = Likelihood.to.recommend~Airline.Status, data = airData)
lm10 <- lm(formula = Likelihood.to.recommend~Partner.Code, data = airData)


#Hint 10#
IndexSVM <- sample(1:dim(airData)[1])
CutOff <- floor(2*dim(airData)[1]/3)
training <- airData[IndexSVM[1:CutOff],]
testing <- airData[IndexSVM[(CutOff+1):dim(airData)[1]],]
ksvm(NPS.Category~Gender, data=training, kernel="rbfdot", kpar="automatic",C=5,cross=3, prob.model=TRUE)
ksvm(NPS.Category ~Type.of.Travel, data=training, kernel="rbfdot", kpar="automatic",C=5,cross=3, prob.model=TRUE)
ksvm(NPS.Category~Class, data=training, kernel="rbfdot",kpar="automatic",C=5,cross=3, probs.model=TRUE)
ksvm(NPS.Category~Airline.Status, data=training, kernel="rbfdot",kpar="automatic",C=5,cross=3, probs.model=TRUE)
ksvm(NPS.Category~Price.Sensitivity, data=training, kernel="rbfdot",kpar="automatic",C=5,cross=3, probs.model=TRUE)

SVMoutput <- ksvm(NPS.Category ~Type.of.Travel, data=training, kernel="rbfdot", kpar="automatic",C=5,cross=3, prob.model=TRUE)
svmPredict <- predict(SVMoutput, testing)
svmPredict <- data.frame(svmPredict)
compare <- data.frame(testing[,37],svmPredict[,1])
table(compare)


