library(ggplot2)
library(maps)
library(plotrix)
library(ggmosaic)

setwd("~/Desktop/College/IST 719/Project Poster")
bbabm <- read.csv("~/Desktop/College/IST 719/Project Poster/Broadband_Availability_By_Municipality.csv")
stacked <- read.csv("~/Desktop/College/IST 719/Project Poster/StackedBarplot.csv")

View(bbabm)
View(stacked)

bbabm$X2010.Muni.Population <- as.numeric(gsub(",","",bbabm$X2010.Muni.Population))
bbabm$X2010.Muni.Housing.Units <- as.numeric(gsub(",","",bbabm$X2010.Muni.Housing.Units))
bbabm$X..Cable.Providers <- as.numeric(bbabm$X..Cable.Providers)
bbabm$X..of.DSL.Providers <- as.numeric(bbabm$X..of.DSL.Providers)
bbabm$X..Fiber.Providers <- as.numeric(bbabm$X..Fiber.Providers)
bbabm$X..Wireline.Providers <- as.numeric(bbabm$X..Wireline.Providers)
bbabm$X..Wireless.Providers <- as.numeric(bbabm$X..Wireless.Providers)
bbabm$X..Satellite.Providers <- as.numeric(bbabm$X..Satellite.Providers)


M.pop.by.region <- tapply(bbabm$X2010.Muni.Population,list(bbabm$REDC.Region),sum)
M.pop.by.region <- M.pop.by.region[!is.na(M.pop.by.region)]
M.houses.by.region <- tapply(bbabm$X2010.Muni.Housing.Units,list(bbabm$REDC.Region),sum)
M.houses.by.region <- M.houses.by.region[!is.na(M.houses.by.region)]

num.cols <- 5
agg_data1 <- aggregate(bbabm$X..Cable.Providers,list(bbabm$County),sum)
agg_data1 <- agg_data1[2:63,]
colnames(agg_data1) <- c("County","CableProviders")
agg_data1$Index <- round(rescale(agg_data1$CableProviders,c(1,5)), 0)
my.cols <- rev(heat.colors(num.cols))
agg_data1$color <- my.cols[agg_data1$Index]

agg_data2 <- aggregate(bbabm$X..of.DSL.Providers,list(bbabm$County),sum)
agg_data2 <- agg_data2[2:63,]
colnames(agg_data2) <- c("County","DSLProviders")
agg_data2$Index <- round(rescale(agg_data2$DSLProviders,c(1,5)), 0)
my.cols <- rev(heat.colors(num.cols))
agg_data2$color <- my.cols[agg_data2$Index]

agg_data3 <- aggregate(bbabm$X..Fiber.Providers,list(bbabm$County),sum)
agg_data3 <- agg_data3[2:63,]
colnames(agg_data3) <- c("County","FiberProviders")
agg_data3$Index <- round(rescale(agg_data3$FiberProviders,c(1,5)), 0)
my.cols <- rev(heat.colors(num.cols))
agg_data3$color <- my.cols[agg_data3$Index]

agg_data4 <- aggregate(bbabm$X..Wireline.Providers,list(bbabm$County),sum)
agg_data4 <- agg_data4[2:63,]
colnames(agg_data4) <- c("County","WirelineProviders")
agg_data4$Index <- round(rescale(agg_data4$WirelineProviders,c(1,5)), 0)
my.cols <- rev(heat.colors(num.cols))
agg_data4$color <- my.cols[agg_data4$Index]

agg_data5 <- aggregate(bbabm$X..Wireless.Providers,list(bbabm$County),sum)
agg_data5 <- agg_data5[2:63,]
colnames(agg_data5) <- c("County","WirelessProviders")
agg_data5$Index <- round(rescale(agg_data5$WirelessProviders,c(1,5)), 0)
my.cols <- rev(heat.colors(num.cols))
agg_data5$color <- my.cols[agg_data5$Index]

agg_data6 <- aggregate(bbabm$X..Satellite.Providers,list(bbabm$County),sum)
agg_data6 <- agg_data6[2:63,]
colnames(agg_data6) <- c("County","SatelliteProviders")
agg_data6$Index <- round(rescale(agg_data6$SatelliteProviders,c(1,5)), 0)
my.cols <- rev(heat.colors(num.cols))
agg_data6$color <- my.cols[agg_data6$Index]

my.cols
View(agg_data1)
View(agg_data2)
View(agg_data3)
View(agg_data4)
View(agg_data5)
View(agg_data6)

cable.reg <- aggregate(bbabm$X..Cable.Providers,list(bbabm$REDC.Region),sum)
dsl.reg <- aggregate(bbabm$X..of.DSL.Providers,list(bbabm$REDC.Region),sum)
fiber.reg <- aggregate(bbabm$X..Fiber.Providers,list(bbabm$REDC.Region),sum)
line.reg <- aggregate(bbabm$X..Wireline.Providers,list(bbabm$REDC.Region),sum)
less.reg <- aggregate(bbabm$X..Wireless.Providers,list(bbabm$REDC.Region),sum)
sat.reg <- aggregate(bbabm$X..Satellite.Providers,list(bbabm$REDC.Region),sum)

View(cable.reg)
View(dsl.reg)
View(fiber.reg)
View(line.reg)
View(less.reg)
View(sat.reg)


stacked.agg <- aggregate(stacked$Number,list(r=stacked$Region,
                                             t=stacked$Broadband.Type),sum)


pie(c(2,3,4,4,5,6,7,13,16,40),main="Population by NYS Region",
    labels=c("North Country","Mohawk Valley","Central New York",
             "Southern Tier Region","Capital Region","Finger Lakes Region",
             "Western New York","Mid-Hudson Region","Long Island",
             "New York City"),
    col=c("#aeffff","#8ff4fe","#6de8ff","#47dcff","#04ceff","#00c0ff",
          "#00b1ff","#00a1ff","#1e90ff","#1874CD"))
pie(c(3,3,4,4,6,7,8,12,14,39),main="Housing Units by NYS Region",
    labels=c("North Country","Mohawk Valley","Central New York",
             "Southern Tier Region","Capital Region","Finger Lakes Region",
             "Western New York","Mid-Hudson Region","Long Island",
             "New York City"),
    col=c("#ffee7a","#fee66d","#fedd5f","#fed452","#fecb45","#fec237",
          "#feb929","#ffaf19","#ffa500","#EE9A00"))

par(mfrow = c(2,3))
map("county","new york", col=agg_data1$color,fill=TRUE,resolution=0,
    border="black")
map("county","new york", col=agg_data2$color,fill=TRUE,resolution=0,
    border="black")
map("county","new york", col=agg_data3$color,fill=TRUE,resolution=0,
    border="black")
map("county","new york", col=agg_data4$color,fill=TRUE,resolution=0,
    border="black")
map("county","new york", col=agg_data5$color,fill=TRUE,resolution=0,
    border="black")
map("county","new york", col=agg_data6$color,fill=TRUE,resolution=0,
    border="Black")

ggplot(stacked.agg) + geom_mosaic(aes(weight=x,x=product(r),
                                  fill=t)) +
    theme_minimal() + xlab("") + ylab("") + theme(legend.position="none",
                                                  panel.border=element_blank(),
                                                  panel.grid=element_blank()) +
    scale_fill_manual(values=c("#1E90FF","#b37ef4","#fd67cb","#ff6290"
                               ,"#ff7e52","#ffa600"))
