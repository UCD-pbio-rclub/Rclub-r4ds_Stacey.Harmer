# 2017-05-03

# just graphing in this version of a previous script

# depiction of tracking disrupted data from Hagop, October
# much of the code recycled from 2015-10-25_growth_trackingVdisrupted and 
# 2016-02-26_growth_trackingVdisrupted scripts.

## 
# start out with the biomass data, both rotated and tethered plants
##

setwd("~/sunflower/growth_when_tracking_disrupted/Oct_2015/final_data_mass_area")
library(ggplot2)
library(grid)
library("cowplot")
library(gridExtra) # has grid.arrange

teth.mass <- read.csv("weight.tethered.csv")
head(teth.mass)
tail(teth.mass)
summary(teth.mass)

#####
## julin points out that stat_summary is using 95% confidence intervals for the error bars
#####
# To use SEM for error bars using stat_summary, must first
# write a function for SEM
mean.sem <- function(x,na.rm=TRUE) {
  if(na.rm) x <- na.omit(x)
  mean.x <- mean(x)
  sem.x <- sd(x)/sqrt(length(x))
  data.frame(
    y=mean.x,
    ymin=mean.x-sem.x,
    ymax=mean.x+sem.x)
}

pl.teth.mass.bar.2 <- pl.teth.mass.bar + 
  stat_summary(fun.y = "mean",geom="bar",position="dodge") + 
  stat_summary(fun.data = "mean.sem",geom="errorbar",position="dodge") + 
  ylab("biomass.tethered")

###########
#  Now make a plot for leaf area for tethered plants
########

teth.leaf.area <- read.csv("area.tethered.leaf.pairs.csv")
head(teth.leaf.area)
tail(teth.leaf.area)
summary(teth.leaf.area)
typeof(teth.leaf.area) #list

#convert row to a factor, not a vector

teth.leaf.area$row <- as.factor(teth.leaf.area$row)

# make a treatment by leaf column
teth.leaf.area$trt.leaf <- paste(teth.leaf.area$trt, teth.leaf.area$leaf, sep =".")
head(teth.leaf.area)

## relevel so I can see comparisons better

teth.leaf.area$trt.leaf <- factor(teth.leaf.area$trt.leaf , levels = c( "C.lf.09.10", "T.lf.09.10",
                                                                        "C.lf.11.12", "T.lf.11.12",
                                                                        "C.lf.13.14", "T.lf.13.14",
                                                                        "C.lf.15.16", "T.lf.15.16",
                                                                        "C.lf.17.18", "T.lf.17.18"))



leaf.area.pairs.teth <- ggplot(teth.leaf.area, aes(x = trt.leaf, y = leaf.area, fill=trt,color=trt))

leaf.area.pairs.teth.4 <- leaf.area.pairs.teth + 
  stat_summary(fun.y = "mean",geom="bar",position="dodge") + 
  stat_summary(fun.data = "mean.sem",geom="errorbar",position="dodge") + 
  ylab("leaf.area.tethered") + xlab("leaf pair")

grid.arrange(pl.teth.mass.bar.2, leaf.area.pairs.teth.4,
             ncol=2, nrow=1, widths=c(2, 3.2), heights=c(1.4))  

