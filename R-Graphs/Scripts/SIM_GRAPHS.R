library(ggplot2)
library(tidyverse)
library(tidyr)
library(dplyr)
library(RColorBrewer)
library(ggsci)
library(viridis)
library(plotly)
library(tidyquant)

setwd(dir = "/Users/bayhi/Desktop/AA-Analysis/")
getwd()

####################################################################
# Get your data in order: 
### Rename each replica batch with the rep number ("*_###.*")
### Sort by type into appropriate folders (coords, hbonds, insSS, rmsd)
### If necessary, add a Rep column to the beginning

########################################################
### InsSS
########################################################

raw.insSS <- tibble(filename=list.files("insSS/"))
setwd(dir = "/Users/bayhi/Desktop/AA-Analysis/insSS/")
insSSdata <- raw.insSS %>%
  rowwise() %>%
  do(., read_csv(file=.$filename))
setwd(dir = "../")

# separate the data into columns for each residue
dfinsSS <- separate(insSSdata, 1, into=c("RepMol", "Frame", "SecStr"), sep="\\!")
dfinsSS$RepMol <- str_sub(dfinsSS$RepMol, end=-6) 
dfinsSS <- separate(dfinsSS, 1, into=c("Rep", "Mol"), sep="\\s")
dfinsSS$Frame <- as.integer(dfinsSS$Frame)
dfinsSS <- mutate(dfinsSS, Nanosec = (Frame *0.222), .before=4) 
# Stride set such that each frame is worth 0.222 ns

#separate 
dfinsSSsep <- separate(dfinsSS, "SecStr", into=as.character(c(0:51)), sep="\\s")
# get rid of 0 residue column
dfinsSSsep  <- select(dfinsSSsep, -"0")
# gather vertically so each residue has its own row
dfinsSSgather <- gather(dfinsSSsep, key="ResID", value="SecStrDSSP8", 5:(ncol(dfinsSSsep)))
# get rid of the no-structure bits at the N and C terminus
dfinsSSgather <- filter(dfinsSSgather, !is.na(SecStrDSSP8))
dfinsSSgather$ResID = as.integer(dfinsSSgather$ResID)

# Reduce DSSP8 assignments to understandable DSSP3 names
dfinsSSgather <- dfinsSSgather %>% mutate(SecStr = case_when(
  SecStrDSSP8 == "B" ~ "Beta",
  SecStrDSSP8 == "C" ~ "Unstr",
  SecStrDSSP8 == "E" ~ "Beta",
  SecStrDSSP8 == "G" ~ "Helix",
  SecStrDSSP8 == "H" ~ "Helix",
  SecStrDSSP8 == "I" ~ "Helix",
  SecStrDSSP8 == "T" ~ "Unstr",
  SecStrDSSP8 == "S" ~ "Unstr"
))

# Graphs of insulin-containing simulations

AAinsSSplot <- ggplot(dfinsSSgather, aes(x=Nanosec, y=ResID, fill=SecStr))+
  geom_tile()+
  ylab("Insulin residue")+
  xlab("Time (ns)")+
  facet_wrap( Mol ~ Rep) +
  geom_hline(aes(yintercept = 14), color="yellow")+
  geom_hline(aes(yintercept = 15), color="yellow")+
  geom_hline(aes(yintercept = 31), color="yellow")+
  geom_hline(aes(yintercept = 32), color="yellow")+
  geom_hline(aes(yintercept = 35), color="yellow")+
  geom_hline(aes(yintercept = 36), color="yellow")+ 
  #adjust location of these annotations appropriately
  annotate("text", label="Cleavage sites", x=50, y=38, col="yellow", size=3)+
  geom_hline(aes(yintercept = 21), color="black")+
  annotate("text", label="Chain break", x=50, y=22, col="black", size=3)+
  ggtitle(paste("Insulin Secondary Structure"))
AAinsSSplot

ggsave("AA-InsSecstr.png", width=11, height=8.5)

########################################################
### Hbond Intx
########################################################

# Import HBond interaction data
setwd(dir = "/Users/bayhi/Desktop/AA-Analysis/")
raw.hbondintx <- tibble(filename=list.files("hbondintx/"))
setwd(dir = "/Users/bayhi/Desktop/AA-Analysis/hbondintx/")
hbidf <- raw.hbondintx %>%
  rowwise() %>%
  do(., read_csv(file=.$filename))
setwd(dir = "../")

# Manipulate Df to create useful columns
dfHBI <- separate(hbidf, 1, into=c("Donor", "Acceptor", "OccFilename"), sep="\\t")
dfHBI <- separate(dfHBI, OccFilename, into=c("Occ", "File"), sep="\\/")
dfHBI$Occ <- str_sub(dfHBI$Occ, start=2, end=2)
dfHBI <- separate(dfHBI, File, into=c("Traj", "Frame", "Rep"), sep="\\-")
dfHBI$Rep<- str_sub(dfHBI$Rep, start=21, end=23)
dfHBI <- separate(dfHBI, Donor, into=c("DonSeg", "DonRes", "DonType"), sep="\\-")
dfHBI <- separate(dfHBI, DonRes, into=c("DonRes", "DonResNum"), sep=3)
dfHBI <- separate(dfHBI, Acceptor, into=c("AccSeg", "AccRes", "AccType"), sep="\\-")
dfHBI <- separate(dfHBI, AccRes, into=c("AccRes", "AccResNum"), sep=3)

# Adjust data types in columns
dfHBI$DonResNum <- as.integer(dfHBI$DonResNum)
dfHBI$AccResNum <- as.integer(dfHBI$AccResNum)
dfHBI$AccSeg <- str_sub(dfHBI$AccSeg, start=2)
dfHBI$Frame <- as.integer(dfHBI$Frame)

# Identify what IDE domain the interaction occurs with
# this works because donor or receptor will be segb, never both. 
# SegB self-bonds and Insulin self-bonds not included in this set
dfHBI <- dfHBI %>% mutate(DomIntx = case_when(
  ((DonSeg == "SegB") & (between(DonResNum, 0, 285))) ~ "D1",
  ((DonSeg == "SegB") & (between(DonResNum, 286, 515))) ~ "D2",
  ((DonSeg == "SegB") & (between(DonResNum, 542, 768))) ~ "D3",
  ((DonSeg == "SegB") & (between(DonResNum, 769, 1016))) ~ "D4",
  ((AccSeg == "SegB") & (between(AccResNum, 0, 285))) ~ "D1",
  ((AccSeg == "SegB") & (between(AccResNum, 286, 515))) ~ "D2",
  ((AccSeg == "SegB") & (between(AccResNum, 542, 768))) ~ "D3",
  ((AccSeg == "SegB") & (between(AccResNum, 769, 1016))) ~ "D4",
  ((DonSeg == "SegE") & (AccSeg == "SegE")) ~ "Ins",
  ((DonSeg == "SegE") & (AccSeg == "SegF")) ~ "Ins",
  ((DonSeg == "SegF") & (AccSeg == "SegF")) ~ "Ins",
  ((DonSeg == "SegF") & (AccSeg == "SegE")) ~ "Ins",
  TRUE ~ "Other"
))

# Create column that accounts for ins chain B with continuous numbering
dfHBI <- mutate(dfHBI, DonResNumShift = (DonResNum + 21))
dfHBI <- mutate(dfHBI, AccResNumShift = (AccResNum + 21))

# if you're insA (segE), use normal numbering
dfHBI <- dfHBI %>% mutate(ResIDe = case_when(
  ((DonSeg == "SegB") & (AccSeg == "SegE")) ~ AccResNum,
  ((DonSeg == "SegE") & (AccSeg == "SegB")) ~ DonResNum,
  ((DonSeg == "SegE") & (AccSeg == "SegE")) ~ DonResNum,
  ((DonSeg == "SegE") & (AccSeg == "SegF")) ~ DonResNum,
))
# if you're insB (segF), use modified numbering
dfHBI <- dfHBI %>% mutate(ResIDf = case_when(
  ((DonSeg == "SegB") & (AccSeg == "SegF")) ~ AccResNumShift,
  ((DonSeg == "SegF") & (AccSeg == "SegB")) ~ DonResNumShift,
  ((DonSeg == "SegF") & (AccSeg == "SegF")) ~ DonResNumShift,
  ((DonSeg == "SegF") & (AccSeg == "SegE")) ~ DonResNumShift,
))

# set the NA's created above to zero...
dfHBI[is.na(dfHBI)] <- 0

# ... so we can add the resids together and get the overall 1-51 ResID
dfHBI <- mutate(dfHBI, ResID = (ResIDe + ResIDf))

# Mol column to match other data
dfHBI <- dfHBI %>% mutate(Mol = case_when(
  (Traj == "00") ~ "00-OCinsA",
  (Traj == "07") ~ "07-OpOinsA"
))

#create modifiable versions
dfSecStrInfo <- dfinsSSgather
dfHbondInfo <- dfHBI 

dfHbondInfo <- dfHbondInfo %>% select(Rep, Mol, Frame, ResID, DomIntx)
head(dfHbondInfo)

dfSecStrHBond <- left_join(dfSecStrInfo, dfHbondInfo, by=c("Rep", "Mol", "Frame", "ResID"))

dfSecStrHBond <- dfSecStrHBond %>% mutate(BetaDomIntx = case_when(
  ((SecStr == "Beta") & (!is.na(DomIntx))) ~ DomIntx,
  TRUE ~ SecStr # change this to only include ins-Beta intx
))

dfSecStrHBond$BetaDomIntx = factor(dfSecStrHBond$BetaDomIntx, 
                                   levels=c("Unstr", "Helix", "Beta", "D1","D2","D3","D4"))
colorz <- c("Unstr" = "darkslategray4", "Helix"="darkslateblue", "Beta"="darkgoldenrod2",
            "D1"="red", "D2"="firebrick", "D3"="orange", "D4"="yellow")

HBIinsSSplot <- ggplot(dfSecStrHBond, aes(x=Nanosec, y=ResID, fill=BetaDomIntx))+
  geom_tile()+
  scale_fill_manual(values = colorz) +
  ylab("Insulin residue")+
  xlab("Time (ns)")+
  facet_wrap( Mol ~ Rep) +
  geom_hline(aes(yintercept = 14), color="pink", size=0.5)+
  geom_hline(aes(yintercept = 15), color="pink", size=0.5)+
  geom_hline(aes(yintercept = 31), color="pink", size=0.5)+
  geom_hline(aes(yintercept = 32), color="pink", size=0.5)+
  geom_hline(aes(yintercept = 35), color="pink", size=0.5)+
  geom_hline(aes(yintercept = 36), color="pink", size=0.5)+ 
  #adjust location of these annotations appropriately
  annotate("text", label="Cleavage sites", x=100, y=38, col="pink", size=3)+
  geom_hline(aes(yintercept = 21), color="black", size=1)+
  annotate("text", label="Chain break", x=100, y=22, col="black", size=3)+
  ggtitle(paste("Insulin Secondary Structure"))
HBIinsSSplot

ggsave("AA-InsSS+HbondInfo+Annotations_Wide.png", width=18, height=8.5)

########################################################
### Coords
########################################################

setwd(dir = "/Users/bayhi/Desktop/AA-Analysis/")
raw.coords <- tibble(filename=list.files("coords/"))
setwd(dir = "/Users/bayhi/Desktop/AA-Analysis/coords/")
coordsData <- raw.coords %>%
  rowwise() %>%
  do(., read_csv(file=.$filename))
setwd(dir = "../")

coordcolumnnames <- strsplit(colnames(coordsData), "\\t")
coordcolumnnames[[1]]
coordcolumnnames <- coordcolumnnames[[1]][-c(1,2,3,4)]
coordcolumnnames
coordcolumnnames <- gsub("-", ".", coordcolumnnames)
coordcolumnnames

dfcoords <- separate(coordsData, 1, into = c("RepMol", "Frame", "Coords"), sep="\\!")
# separate the data into columns for each residue
dfcoords$RepMol <- str_sub(dfcoords$RepMol, end=-6)
dfcoords <- separate(dfcoords, 1, into=c("Rep", "Mol"), sep="\\s")
dfcoords <- separate(dfcoords, Coords, into = coordcolumnnames, sep="\\s")
dfcoords <- select(dfcoords, -"!")
dfcoords$Frame <- as.integer(dfcoords$Frame)
dfcoords <- mutate(dfcoords, Nanosec = (Frame *0.222), .before=4) 
# Stride set such that each frame is worth 0.222 ns
numeric_columns <- c(4:ncol(dfcoords))
dfcoords[numeric_columns] <- sapply(dfcoords[numeric_columns],as.numeric)

# Dist from Zn to major cleavage sites on insA and insB
dfcoords <- dfcoords %>% mutate(BZnInsAYQ = case_when(
  Mol == "00-OCinsA" ~ sqrt((Bzn.X-insAYQ.X)^2+(Bzn.Y-insAYQ.Y)^2+(Bzn.Z-insAYQ.Z)^2),
  Mol == "07-OpOinsA" ~ sqrt((Bzn.X-insAYQ.X)^2+(Bzn.Y-insAYQ.Y)^2+(Bzn.Z-insAYQ.Z)^2),
  TRUE ~ NaN
))

dfcoords <- dfcoords %>% mutate(BZnInsBHL = case_when(
  Mol == "00-OCinsA" ~ sqrt((Bzn.X-insBHL.X)^2+(Bzn.Y-insBHL.Y)^2+(Bzn.Z-insBHL.Z)^2),
  Mol == "07-OpOinsA" ~ sqrt((Bzn.X-insBHL.X)^2+(Bzn.Y-insBHL.Y)^2+(Bzn.Z-insBHL.Z)^2),
  TRUE ~ NaN
))

# Chain A hinge (D1-D4 distance)
dfcoords <- mutate(dfcoords, AD1D4 = sqrt((AD1.X-AD4.X)^2+(AD1.Y-AD4.Y)^2+(AD1.Z-AD4.Z)^2))
# Chain B hinge (D1-D4 distance)
dfcoords <- mutate(dfcoords, BD1D4 = sqrt((BD1.X-BD4.X)**2+(BD1.Y-BD4.Y)**2+(BD1.Z-BD4.Z)**2))

#from https://stackoverflow.com/questions/15162741/what-is-rs-crossproduct-function#:~:text=One%20definition%20of%20the%20vector,*By%20%2D%20Ay*Bx%20.
CrossProd3d <- function(x, y, i=1:3) {
  # Project inputs into 3D, since the cross product only makes sense in 3D.
  To3D <- function(x) head(c(x, rep(0, 3)), 3)
  x <- To3D(x)
  y <- To3D(y)
  # Indices should be treated cyclically (i.e., index 4 is "really" index 1, and
  # so on).  Index3D() lets us do that using R's convention of 1-based (rather
  # than 0-based) arrays.
  Index3D <- function(i) (i - 1) %% 3 + 1
  # The i'th component of the cross product is:
  # (x[i + 1] * y[i + 2]) - (x[i + 2] * y[i + 1])
  # as long as we treat the indices cyclically.
  return (x[Index3D(i + 1)] * y[Index3D(i + 2)] -
            x[Index3D(i + 2)] * y[Index3D(i + 1)])
}

dihenu <- function(ax, ay, az, bx, by, bz, cx, cy, cz, dx, dy, dz){
  a = c(ax, ay, az)
  b = c(bx, by, bz)
  c = c(cx, cy, cz)
  d = c(dx, dy, dz)
  vAB = b-a
  vBC = c-b
  vCD = d-c
  n1 = CrossProd3d(vAB, vBC) / sqrt(sum((CrossProd3d(vAB, vBC))**2))
  n2 = CrossProd3d(vBC, vCD) / sqrt(sum((CrossProd3d(vBC, vCD))**2))
  vBCunit = vBC / sqrt(sum(vBC**2))
  m1 = CrossProd3d(n1, vBCunit)
  x = n1 %*% n2
  y = m1 %*% n2
  result = atan2(y, x) * 180 / pi
  return(result)
}

dihenu = Vectorize(dihenu)

# Dihedrals for A and B chain
dfcoords <- mutate(dfcoords, Adih = dihenu(AD1.X, AD1.Y, AD1.Z, AD2.X, AD2.Y, AD2.Z, 
                                               AD3.X, AD3.Y, AD3.Z, AD4.X, AD4.Y, AD4.Z))
dfcoords <- mutate(dfcoords, Bdih = dihenu(BD1.X, BD1.Y, BD1.Z, BD2.X, BD2.Y, BD2.Z, 
                                           BD3.X, BD3.Y, BD3.Z, BD4.X, BD4.Y, BD4.Z))
print("Mischief managed")

savepoint <- dfcoords
write.csv(savepoint,"dfcoordssave.csv", row.names = FALSE)

dfcoordsgeom <- select(dfcoords, Mol, Rep, Frame, Nanosec, AD1D4:Bdih)

dfcoordsgeomgather<- gather(dfcoordsgeom, key="Stat", value = "Value", 5:8)
dfcoordsgeomgather$Stat <- as.factor(dfcoordsgeomgather$Stat)

#allgeom_plot <- ggplot(dfcoordsgather, aes(Frame, Value, group=Rep))+
geom_plot <- ggplot(dfcoordsgeomgather, aes(Nanosec, Value))+
  geom_line(aes(color=Stat), size=0.5)+
  ylab("Value (Angstroms/Degrees)")+
  xlab("Time (ns)") +
  facet_grid( Rep ~ Mol ) +
  ggtitle(paste("Geometry"))
geom_plot

ggsave("AA-Geom.png", width=11, height=8.5)

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










