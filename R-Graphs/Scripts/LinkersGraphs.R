install.packages("stringr")

library(ggplot2)
library(tidyverse)
library(tidyr)
library(dplyr)
library(RColorBrewer)
library(ggsci)
library(viridis)
library(plotly)
library(tidyquant)
library(stringr)

setwd(dir = "/Users/Vidyo/Desktop/SIR/coords")
getwd()

####################################################################
# Get your data in order: 
### Rename each replica batch with the rep number ("*_###.*")
### Sort by type into appropriate folders (coords, hbonds, insSS, rmsd)
### If necessary, add a Rep column to the beginning

########################################################
### NEPcoords
########################################################

setwd(dir = "/Users/Vidyo/Desktop/SIR/")
raw.NEPcoords <- tibble(filename=list.files("coords/"))
setwd(dir = "/Users/Vidyo/Desktop/SIR/coords/")
NEPcoordsData <- raw.NEPcoords %>%
  rowwise() %>%
  do(., read_csv(file=.$filename))
setwd(dir = "../")

head(NEPcoordsData)

coordcolumnnames <- strsplit(colnames(NEPcoordsData), "\\t")
coordcolumnnames[[1]]
coordcolumnnames <- coordcolumnnames[[1]][-c(1,2,3)]
coordcolumnnames
coordcolumnnames <- gsub("-", ".", coordcolumnnames)
coordcolumnnames

dfNEPcoords <- separate(NEPcoordsData, 1, into = c("RepMol", "Frame", "D1a", "D1b", "D1AandB", "D2", "S1", "S2", "S3", "S4", "Zn", "S1andS2", "S1andS3", "S1andS4", "S2andS3", "S2andS4", "S3andS4", "S1andS2andS3andS4", "S1andS2andS3", "S2andS3andS4", "S1andS3andS4", "S1andS2andS4"), sep="\\!")
head(dfNEPcoords)

 dfNEPcoords$RepMol <- str_sub(dfNEPcoords$RepMol, end=-5) 
 
 dfNEPcoords <- separate(dfNEPcoords, col="D1a", into = c("D1a.X", "D1a.Y", "D1a.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="D1b", into = c("D1b.X", "D1b.Y", "D1b.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="D1AandB", into = c("D1AandB.X", "D1AandB.Y", "D1AandB.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="D2", into = c("D2.X", "D2.Y", "D2.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1", into = c("S1.X", "S1.Y", "S1.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S2", into = c("S2.X", "S2.Y", "S2.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S3", into = c("S3.X", "S3.Y", "S3.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S4", into = c("S4.X", "S4.Y", "S4.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="Zn", into = c("Zn.X", "Zn.Y", "Zn.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1andS2", into = c("S1andS2.X", "S1andS2.Y", "S1andS2.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1andS3", into = c("S1andS3.X", "S1andS3.Y", "S1andS3.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1andS4", into = c("S1andS4.X", "S1andS4.Y", "S1andS4.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S2andS3", into = c("S2andS3.X", "S2andS3.Y", "S2andS3.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S2andS4", into = c("S2andS4.X", "S2andS4.Y", "S2andS4.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S3andS4", into = c("S3andS4.X", "S3andS4.Y", "S3andS4.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1andS2andS3andS4", into = c("S1andS2andS3andS4.X", "S1andS2andS3andS4.Y", "S1andS2andS3andS4.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1andS2andS3", into = c("S1andS2andS3.X", "S1andS2andS3.Y", "S1andS2andS3.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S2andS3andS4", into = c("S2andS3andS4.X", "S2andS3andS4.Y", "S2andS3andS4.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1andS3andS4", into = c("S1andS3andS4.X", "S1andS3andS4.Y", "S1andS3andS4.Z"), sep="\\s")
 dfNEPcoords <- separate(dfNEPcoords, col="S1andS2andS4", into = c("S1andS2andS4.X", "S1andS2andS4.Y", "S1andS2andS4.Z"), sep="\\s")
 
 head(dfNEPcoords)
 
 dfNEPcoords$Frame <- as.integer(dfNEPcoords$Frame)
 dfNEPcoords <- mutate(dfNEPcoords, Nanosec = (Frame * 0.222), .before=3)
 # Stride set such that each frame is worth 0.22 ns
 numeric_columns <- c(4:ncol(dfNEPcoords))
 dfNEPcoords[numeric_columns] <- sapply(dfNEPcoords[numeric_columns],as.numeric)

dfNEPcoords <- mutate(dfNEPcoords, D1D2dist = sqrt (((D1AandB.X-D2.X)^2+(D1AandB.Y-D2.Y)^2+(D1AandB.Z-D2.Z)^2)))
head(dfNEPcoords)
dfNEPcoords <- mutate(dfNEPcoords, D1aD2dist = sqrt (((D1a.X-D2.X)^2+(D1a.Y-D2.Y)^2+(D1a.Z-D2.Z)^2)))
dfNEPcoords <- mutate(dfNEPcoords, D1bD2dist = sqrt (((D1b.X-D2.X)^2+(D1b.Y-D2.Y)^2+(D1b.Z-D2.Z)^2)))

calculateAngle <- function(linkerX, linkerY, linkerZ, NameInput){
  vectorABX = (linkerX - dfNEPcoords$D1AandB.X)
  vectorABY = (linkerY - dfNEPcoords$D1AandB.Y)
  vectorABZ = (linkerZ - dfNEPcoords$D1AandB.Z)
  
  vectorBCX = (dfNEPcoords$D2.X - linkerX)
  vectorBCY = (dfNEPcoords$D2.Y - linkerY)
  vectorBCZ = (dfNEPcoords$D2.Z - linkerZ)
  
  calc_dotproduct = (vectorABX*vectorBCX + vectorABY*vectorBCY + vectorABZ*vectorBCZ)
  
  calc_magnitudeAB = (sqrt((vectorABX)^2+(vectorABY)^2+(vectorABZ)^2))
  calc_magnitudeBC = (sqrt((vectorBCX)^2+(vectorBCY)^2+(vectorBCZ)^2))
  
  return (acos((calc_dotproduct)/(calc_magnitudeAB*calc_magnitudeBC))*(180/pi))
}

calculateAngle2 <- function(linkerX, linkerY, linkerZ, NameInput){
  vectorABX = (dfNEPcoords$D1AandB.X - linkerX)
  vectorABY = (dfNEPcoords$D1AandB.Y - linkerY)
  vectorABZ = (dfNEPcoords$D1AandB.Z - linkerZ)
  
  vectorBCX = (dfNEPcoords$D2.X - linkerX)
  vectorBCY = (dfNEPcoords$D2.Y - linkerY)
  vectorBCZ = (dfNEPcoords$D2.Z - linkerZ)
  
  v1mag = (sqrt((vectorABX)^2+(vectorABY)^2+(vectorABZ)^2))
  v1normx = vectorABX/v1mag
  v1normy = vectorABY/v1mag
  v1normz = vectorABZ/v1mag
  
  v2mag = (sqrt((vectorBCX)^2+(vectorBCY)^2+(vectorBCZ)^2))
  v2normx = vectorBCX/v1mag
  v2normy = vectorBCY/v1mag
  v2normz = vectorBCZ/v1mag
  
  res = (v1normx*v2normx + v1normy*v2normy + v1normz*v2normz)
  
  return (acos(res)*(180/pi))
}

tempoutput = calculateAngle2(dfNEPcoords$S1andS2.X, dfNEPcoords$S1andS2.Y, dfNEPcoords$S1andS2.Z, "S1andS2")
dfNEPcoords <- mutate(dfNEPcoords, S1andS2angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S1andS3.X, dfNEPcoords$S1andS3.Y, dfNEPcoords$S1andS3.Z, "S1andS3")
dfNEPcoords <- mutate(dfNEPcoords, S1andS3angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S1andS4.X, dfNEPcoords$S1andS4.Y, dfNEPcoords$S1andS4.Z, "S1andS4")
dfNEPcoords <- mutate(dfNEPcoords, S1andS4angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S2andS3.X, dfNEPcoords$S2andS3.Y, dfNEPcoords$S2andS3.Z, "S2andS3")
dfNEPcoords <- mutate(dfNEPcoords, S2andS3angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S2andS4.X, dfNEPcoords$S2andS4.Y, dfNEPcoords$S2andS4.Z, "S1andS2")
dfNEPcoords <- mutate(dfNEPcoords, S2andS4angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S3andS4.X, dfNEPcoords$S3andS4.Y, dfNEPcoords$S3andS4.Z, "S3andS4")
dfNEPcoords <- mutate(dfNEPcoords, S3andS4angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S1andS2andS3andS4.X, dfNEPcoords$S1andS2andS3andS4.Y, dfNEPcoords$S1andS2andS3andS4.Z, "S1andS2")
dfNEPcoords <- mutate(dfNEPcoords, S1andS2andS3andS4angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S1andS2andS3.X, dfNEPcoords$S1andS2andS3.Y, dfNEPcoords$S1andS2andS3.Z, "S3andS4")
dfNEPcoords <- mutate(dfNEPcoords, S1andS2andS3angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S2andS3andS4.X, dfNEPcoords$S2andS3andS4.Y, dfNEPcoords$S2andS3andS4.Z, "S3andS4")
dfNEPcoords <- mutate(dfNEPcoords, S2andS3andS4angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S1andS3andS4.X, dfNEPcoords$S1andS3andS4.Y, dfNEPcoords$S1andS3andS4.Z, "S1andS2")
dfNEPcoords <- mutate(dfNEPcoords, S1andS3andS4angle = tempoutput)

tempoutput = calculateAngle2(dfNEPcoords$S1andS2andS4.X, dfNEPcoords$S1andS2andS4.Y, dfNEPcoords$S1andS2andS4.Z, "S1andS2")
dfNEPcoords <- mutate(dfNEPcoords, S1andS2andS4angle = tempoutput)

savepoint <- dfNEPcoords
write.csv(savepoint,"dfNEPcoords.csv", row.names = FALSE)



###
# This is for movement and distance and stuff
###
head(dfNEPcoords)
dfNEPcoordsgeom <-select(dfNEPcoords, RepMol, Frame, Nanosec, D1D2dist:D1bD2dist)
head(dfNEPcoordsgeom)

dfNEPcoordsgeomgather<- gather(dfNEPcoordsgeom, key="Stat", value = "Value", 4:ncol(dfNEPcoordsgeom))
dfNEPcoordsgeomgather$Stat <- as.factor(dfNEPcoordsgeomgather$Stat)
head(dfNEPcoordsgeomgather)

#allgeom_plot <-ggplot(dfNEPcoordsgather, aes(Frame, Value, group=Rep))+
geom_plot <- ggplot(dfNEPcoordsgeomgather, aes(x=Nanosec, y=Value))+
  geom_line(aes(color=Stat), size=.5)+
  ylab("Value (Angstroms)")+
  xlab("Time (ns)") +
  facet_wrap( ~ RepMol ) +
  ggtitle(paste("NEP geometry, AA NEP"))
geom_plot

ggsave("NEPgeom_AAUp.png", width=11, height=8.5)


###
# This is for angles at hinge
###
dfNEPcoordsgeom <-select(dfNEPcoords, RepMol, Frame, Nanosec, S1andS2angle:S1andS2andS4angle)
head(dfNEPcoordsgeom)

dfNEPcoordsgeomgather<- gather(dfNEPcoordsgeom, key="Stat", value = "Value", 4:ncol(dfNEPcoordsgeom))
dfNEPcoordsgeomgather$Stat <- as.factor(dfNEPcoordsgeomgather$Stat)
head(dfNEPcoordsgeomgather)

#allgeom_plot <-ggplot(dfNEPcoordsgather, aes(Frame, Value, group=Rep))+
geom_plot <- ggplot(dfNEPcoordsgeomgather, aes(x=Nanosec, y=Value))+
  geom_line(aes(color=Stat), alpha = 0.15, size= .25)+
  geom_ma(ma_fun = SMA, n = 50, size = 1, aes(color=Stat), linetype="solid")+
  ylab("Degrees at hinge")+
  xlab("Time (ns)") +
  facet_wrap( ~ RepMol ) +
  ggtitle(paste("Degrees at Hinge vs Time"))
geom_plot

ggsave("NEPandZMP1Hinge.png", width=11, height=8.5)