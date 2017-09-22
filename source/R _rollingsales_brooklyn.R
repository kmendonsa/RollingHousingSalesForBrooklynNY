# Author: Benjamin Reddy
# Taken from pages 49-50 of O'Neil and Schutt

#require(gdata)
#require(plyr) #Added by Monnie McGee
#install the gdata and plyr packages and load in to R.
library(plyr)
library(gdata)

#setwd("C:/MSDS 6306-FALL2016/404/Live session 06")
setwd("C://Users//mendkev//Documents//SMU//MSDS6306_Woo//MSDS6306//RollingHousingSalesForNYC//data")

## You need a perl interpreter to do this on Windows.
installXLSXsupport(perl = "C:/Perl64/bin/perl.exe", verbose = FALSE)
perl <- "C:/Perl64/bin/perl.exe"

## It's automatic in Mac

# So, save the file as a csv and use read.csv instead
# bk <- read.csv("rollingsales_brooklyn.csv",skip=4,header=TRUE)
bk6 <- read.xls ("http://www1.nyc.gov/assets/finance/downloads/pdf/rolling_sales/rollingsales_brooklyn.xls",skip=4,header=TRUE,perl="C:/Perl64/bin/perl.exe")
#              perl="C:/Perl64/bin/perl.exe"
#set max print option to see all rows of data loaded
#options(max.print=999999)

#CHECK the data loaded to bk
bk

## Check the data
head(bk)
summary(bk$building.class.category)
list(summary(bk$building.class.category))
str(bk) # Very handy function!
class(bk)
dim(bk)
nrow(bk)
object.size(bk)
names(bk)
table(bk$building.class.category)
lapply(bk, class)
as.character(lapply(bk, class))
as.character(sapply(bk, class))
summary(bk$year.built)


## clean/format the data with regular expressions
## More on these later. For now, know that the
## pattern "[^[:digit:]]" refers to members of the variable name that
## start with digits. We use the gsub command to replace them with a blank space.
# We create a new variable that is a "clean' version of sale.price.
# And sale.price.n is numeric, not a factor.
bk$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", bk$SALE.PRICE))
count(is.na(bk$SALE.PRICE.N))

names(bk) <- tolower(names(bk)) # make all variable names lower case

## TODO: Get rid of leading digits bk$gross.square.feet as above bk$SALE.PRICE
## names(bk)

bk$gross.square.feet <- as.numeric(gsub("[^[:digit:]]","", bk$gross.square.feet))

# TODO: Get rid of leading digits of bk$land.sqft as above bk$SALE.PRICE
bk$land.square.feet <- as.numeric(gsub("[^[:digit:]]","", bk$land.square.feet))
  
bk$year.built <- as.numeric(as.character(bk$year.built))

## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
names(bk)
attach(bk)
hist(sale.price.n) 
detach(bk)

## keep only the actual sales
bk.sale <- bk[bk$sale.price.n!=0,]
head(bk.sale)
plot(bk.sale$gross.square.feet,bk.sale$sale.price.n)
plot(log10(bk.sale$gross.square.feet),log10(bk.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
bk.homes <- bk.sale[which(grepl("FAMILY",bk.sale$building.class.category)),]
dim(bk.homes)
table(bk.homes$building.class.category)


# TODO: complete plot() with log10 of bk.homes$gross.sqft,bk.homes$sale.price.n
#   as above "bk.sale"
plot(log10(bk.homes$gross.square.feet),log10(bk.homes$sale.price.n))
summary(bk.homes[which(bk.homes$sale.price.n<100000),])


## remove outliers that seem like they weren't actual sales
bk.homes$outliers <- (log10(bk.homes$sale.price.n) <=5) + 0


# TODO: find out homes that meets bk.homes$outliers==0
bk.homes <- bk.homes[which(bk.homes$sale.price.n==0),]

plot(log10(bk.homes$gross.square.feet),log10(bk.homes$sale.price.n))
