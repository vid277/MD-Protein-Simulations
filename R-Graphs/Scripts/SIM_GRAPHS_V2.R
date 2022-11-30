install.packages("ggplot2")
install.packages("tidyverse")
install.packages("tidyr")
install.packages("dplyr")
install.packages("RColorBrewer")
install.packages("ggsci")
install.packages("viridis")
install.packages("plotly")
install.packages("tidyquant")

library(ggplot2)
library(tidyverse)
library(tidyr)
library(dplyr)
library(RColorBrewer)
library(ggsci)
library(viridis)
library(plotly)
library(tidyquant)

setwd(dir = "/Users/Vidyo/Desktop/SIR/coords")
getwd()

####################################################################
# Get your data in order: 
### Rename each replica batch with the rep number ("*_###.*")
### Sort by type into appropriate folders (coords, hbonds, insSS, rmsd)
### If necessary, add a Rep column to the beginning

########################################################
### Coords
########################################################

setwd(dir = "/Users/Vidyo/Desktop/SIR")
raw.coords <- tibble(filename=list.files("coords/"))
setwd(dir = "/Users/Vidyo/Desktop/SIR/coords/")
coordsData <- raw.coords %>%
  rowwise() %>%
  do(., read_csv(file=.$filename))
setwd(dir = "../")

coordcolumnnames <- strsplit(colnames(coordsData), "\\t")
coordcolumnnames[[1]]
coordcolumnnames <- coordcolumnnames[[1]][-c(1,2,3)]
coordcolumnnames
coordcolumnnames <- gsub("-", ".", coordcolumnnames)
coordcolumnnames

dfcoords <- separate(coordsData, 1, into = c("RepMol", "Frame", "Coords"), sep="\\!")
head(dfcoords)

dfcoords$RepMol <- str_sub(dfcoords$RepMol, end=-6)

dfcoords <- separate(dfcoords, Coords, into = coordcolumnnames, sep="\\s")
head(dfcoords)

dfcoords <- select(dfcoords, -"!")
dfcoords$Frame <- as.integer(dfcoords$Frame)

dfcoords <- mutate(dfcoords, Nanosec = (Frame *0.222), .before=3)

# Stride set such that each frame is worth 0.222 ns
numeric_columns <- c(3:ncol(dfcoords))
dfcoords[numeric_columns] <- sapply(dfcoords[numeric_columns],as.numeric)

dfcoords <- mutate(dfcoords, D1aD2 = sqrt(((D1A.X-D2.X)^2+(D1A.Y-D2.Y)^2+(D1A.Z-D2.Z)^2)))
dfcoords <- mutate(dfcoords, D1bD2 = sqrt((D1B.X-D2.X)^2+(D1B.Y-D2.Y)^2+(D1B.Z-D2.Z)^2))

savepoint <- dfcoords
write.csv(savepoint,"dfcoordssave.csv", row.names = FALSE)

dfcoordsgeom <- select(dfcoords, RepMol, Frame, Nanosec, D1aD2:D1bD2)

head(dfcoordsgeom)

dfcoordsgeomgather<- gather(dfcoordsgeom, key="Stat", value = "Value", 4:ncol(dfcoordsgeom))
dfcoordsgeomgather$Stat <- as.factor(dfcoordsgeomgather$Stat)

head(dfcoordsgeomgather)

#allgeom_plot <- ggplot(dfcoordsgather, aes(Frame, Value, group=Rep))+
geom_plot <- ggplot(dfcoordsgeomgather, aes(x=Nanosec, y=Value))+
  geom_line(aes(color=Stat), size=0.5)+
  ylab("Value (Angstroms)")+
  xlab("Time (ns)") +
  facet_wrap( ~RepMol )
  #facet_grid( Rep ~ Mol ) +
  ggtitle(paste("NEP Geometry, AA + Upside"))
geom_plot

ggsave("NEPGeom_AA+UP.png", width=11, height=8.5)

#As above, but with the distance from Zn to Insulin
dfcoordsgeomZn <- select(dfcoords, Mol, Rep, Frame, Nanosec, BZnInsAYQ:Bdih)

dfcoordsgeomZngather<- gather(dfcoordsgeomZn, key="Stat", value = "Value", 5:10)
dfcoordsgeomZngather$Stat <- as.factor(dfcoordsgeomZngather$Stat)

#allgeom_plot <- ggplot(dfcoordsgather, aes(Frame, Value, group=Rep))+
geomZn_plot <- ggplot(dfcoordsgeomZngather, aes(Nanosec, Value))+
  geom_line(aes(color=Stat), size=0.5)+
  ylab("Value (Angstroms/Degrees)")+
  xlab("Time (ns)") +
  facet_grid( Rep ~ Mol ) +
  ggtitle(paste("Geometry"))
geomZn_plot

ggsave("AA-Geom+Zn.png", width=11, height=8.5)


########################################################
### XY Rainbow Plot
########################################################

xydf <- dfcoordsgeomgather
xydf <- mutate(xydf, Chain = substr(xydf$Stat, 1, 1))
xydf$Stat <- substring(xydf$Stat, 2)
xydfspread <- spread(xydf, key=Stat, value = Value)

closed_point <- xydfspread %>% slice(which(Frame == 0))
#set these to match the values for 00 B chain (row 2)
closed_point$D1D4 = closed_point$D1D4[2]
closed_point$dih = closed_point$dih[2]
open_point <- xydfspread %>% slice(which(Frame == 0))
#set these to match the values for 00 A chain (row 1)
open_point$D1D4 = open_point$D1D4[1]
open_point$dih = open_point$dih[1]
pointmerge <- bind_rows(closed_point, open_point)


Axyplot <- ggplot(xydfspread, aes(D1D4, dih, group=Chain))+
  geom_point(aes(color=Nanosec), size=0.5)+
  geom_path(aes(color=Nanosec), size=0.25)+
  scale_colour_gradientn(colors=rainbow(7))+
  geom_line(data = pointmerge, aes(x=D1D4, y=dih), linetype="dashed")+
  facet_grid( Rep ~ Mol )+
  geom_point(data=open_point, aes(x=D1D4, y=dih), col="black", size=2)+
  annotate("text", label="Open", x=50, y=23, col="black", size=3)+
  geom_point(data=closed_point, aes(x=D1D4, y=dih), col="black", size=2)+
  annotate("text", label="Closed", x=35, y=18, col="black", size=3)+
  labs(x="D1-D4 Distance (Angstroms)", y="Dihedral (Degrees)", color='Time (ns)')+
  ggtitle("Distance x Dihedral")
Axyplot
ggsave("AA-XYrainbow.png", width=11, height=8.5)

########################################################
### RMSD Plots
########################################################

raw.rmsd <- tibble(filename=list.files("rmsd/"))
setwd(dir = "/Users/bayhi/Desktop/AA-Analysis/rmsd/")
rmsdData <- raw.rmsd %>%
  rowwise() %>%
  do(., read_csv(file=.$filename))
setwd(dir = "../")

rmsdcolumnnames <- strsplit(colnames(rmsdData), "\\t")
rmsdcolumnnames <- rmsdcolumnnames[[1]][-c(1,2,3,4)]
rmsdcolumnnames <- gsub("-", ".", rmsdcolumnnames)
rmsdcolumnnames

dfrmsd <- separate(rmsdData, 1, into = c("RepMol", "Frame", "RMSDs"), sep="\\!")
# separate the data into columns for each residue
dfrmsd$RepMol <- str_sub(dfrmsd$RepMol, end=-6) 
dfrmsd <- separate(dfrmsd, 1, into=c("Rep", "Mol"), sep="\\s")
dfrmsd <- separate(dfrmsd, RMSDs, into = rmsdcolumnnames, sep="\\s")
dfrmsd <- select(dfrmsd, -"!")
dfrmsd$Frame <- as.integer(dfrmsd$Frame)
dfrmsd <- mutate(dfrmsd, Nanosec = (Frame *0.222), .before=4) 
# Stride set such that each frame is worth 0.222 ns
numeric_columns <- c(4:ncol(dfrmsd))
dfrmsd[numeric_columns] <- sapply(dfrmsd[numeric_columns],as.numeric)

dfrmsdgather <- gather(dfrmsd, key="Reference", value="RMSD", 5:10)

dfrmsdgatherTrim <- filter(dfrmsdgather, Nanosec > .25 )

rmsdplot <- ggplot(dfrmsdgatherTrim, aes(Nanosec, RMSD))+
  geom_line(aes(color=Reference), alpha = 0.5, size=0.25)+
  geom_ma(ma_fun = SMA, n=50, size=1, aes(color=Reference, linetype="-"))+
  ylab(paste("RMSD (Angstroms)")) +
  xlab("Frame") +
  facet_wrap( Rep ~ Mol ) # three columns
rmsdplot

ggsave("AA-RMSDs.png", width=11, height=8.5)










