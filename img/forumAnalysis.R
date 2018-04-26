##############################################
# R Script:   forumAnalysis.R
# Project:    Data Analysis on Forum
#
# Date:       16/8/2017
# Author:     Xun Guo Wong, Putri Wijaya
#
##############################################

###################################
# Packages  
install.packages("plotly")
library(plotly)
library(ggplot2)
install.packages("wesanderson")
library(wesanderson)
install.packages("beeswarm")
library(beeswarm)
install.packages("dygraphs")
library(dygraphs)
###################################
options(max.print = 300000)

webforum <- read.csv("webforum.csv")
attach(webforum)

### 2.0
# Class of each column
sapply(webforum, class)
### Clean Data Frame
# Remove anonymous author
webforum = webforum[!(webforum$AuthorID==-1),]
# Remove 0 word count
webforum = webforum[!(webforum$WC==0),]
# Check for same post ID
samePostID = data.frame(table(webforum$PostID))
samePostID[samePostID$Freq>1]
# Drop column "i','we','you','she/he','they', and 'number
webforum = webforum[-c(12,13,14,15,16,17)]
# Convert Date to "Date" Format
webforum$Date = as.Date(as.character(webforum$Date), format = "%Y-%m-%d")


### 3.1
# Split to unique threads
splittedforum = split(webforum, webforum$ThreadID)
head(splittedforum)
NROW(splittedforum)
splittedforum[1]

# Get random sample of 3 threads from 260 threads
sampleThread = splittedforum[sample(1:NROW(splittedforum), 3)]
head(sampleThread)
NROW(sampleThread)
sampleThread[1]

# first thread = 58817
first = as.data.frame(sampleThread[1])
first
nrow(first)

# second thread = 418903
second = as.data.frame(sampleThread[5])
second
nrow(second)

# third thread = 457478
third = as.data.frame(sampleThread[3])
third
nrow(third)


### 3.1.1
# Level of interaction between authors in a thread
first
first['Days'] = weekdays(as.Date(first$X58817.Date))
second['Days'] = weekdays(as.Date(second$X418903.Date))
third['Days'] = weekdays(as.Date(third$X457478.Date))

# Specify which day comes first
dayLabs<-c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday") 
first$Days <- factor(first$Days, levels= dayLabs)
second$Days <- factor(second$Days, levels= dayLabs)
third$Days <- factor(third$Days, levels= dayLabs)

# Plotting beeswarm
beeswarm(first$X58817.PostID~first$Days, data = first,col=3:10,pch=16, 
         main="Thread ID 58817 Level of Interaction", xlab="Days of the week", ylab="Post ID")
beeswarm(second$X418903.PostID~second$Days, data = first,col=3:10,pch=16, 
         main="Thread ID 418903 Level of Interaction", xlab="Days of the week", ylab="Post ID")
beeswarm(third$X457478.PostID~third$Days, data = first,col=3:10,pch=16, 
         main="Thread ID 457478 Level of Interaction", xlab="Days of the week", ylab="Post ID")


### 3.1.2
# Bar chart to determine which personal concerns is highest among thread
# Get the mean of each personal concerns for each of the threads
meanWorkF = mean(first$X58817.work)
meanWorkS = mean(second$X418903.work)
meanWorkT = mean(third$X457478.work)
work = c(meanWorkF,meanWorkS,meanWorkT)
meanLeisureF = mean(first$X58817.leisure)
meanLeisureS = mean(second$X418903.leisure)
meanLeisureT = mean(third$X457478.leisure)
leisure = c(meanLeisureF,meanLeisureS,meanLeisureT)
meanHomeF = mean(first$X58817.home)
meanHomeS = mean(second$X418903.home)
meanHomeT = mean(third$X457478.home)
home = c(meanHomeF, meanHomeS, meanHomeT)
meanMoneyF = mean(first$X58817.money)
meanMoneyS = mean(second$X418903.money)
meanMoneyT = mean(third$X457478.money)
money = c(meanMoneyF, meanMoneyS, meanMoneyT)
meanReligF = mean(first$X58817.relig)
meanReligS = mean(second$X418903.relig)
meanReligT = mean(third$X457478.relig)

# Grouping them 
relig = c(meanReligF, meanReligS, meanReligT)
threads = c("58817","418903","457478")

# Create a data frame to plot
data = data.frame(threads, work, leisure, home, money, relig)
data$threads <- factor(data$threads, levels = c("58817","418903","457478"))
plot_ly(data, x = ~threads, y=~work, type ='bar', name= 'Work')%>%
  add_trace(y=~leisure, name ="Leisure") %>%
  add_trace(y=~home, name ="Home") %>%
  add_trace(y=~money, name ="Money") %>%
  add_trace(y=~relig, name ="Religion") %>%
  layout(yaxis = list(title ='Mean'), xaxis=list(title='Thread ID'), barmode = 'group', title = "Personal concerns in threads")
data


### 3.1.3
# Group by authorID in Thread 1
splittedAuthor = split(first, first[3])
head(splittedAuthor)
length(splittedAuthor)

a = aggregate(first[7], first[3],mean)
# Pie chart of author ID and analytic
p1 = plot_ly(a, labels = ~X58817.AuthorID, values = ~ X58817.Analytic, type = 'pie', textposition = 'inside', textinfo = 'label+percent')%>%
  layout(title = 'LIWC Summary Analytic on AuthorID in ThreadID 58817', showlegend = T)
p1

# Group by authorID in Thread 2
splittedAuthor2 = split(second, second[3])
head(splittedAuthor2)
length(splittedAuthor2)

b = aggregate(second[7], second[3],mean)
# Pie chart of author ID and analytic
p2 = plot_ly(b, labels = ~X418903.AuthorID, values = ~ X418903.Analytic, type = 'pie', textposition = 'inside', textinfo = 'label+percent')%>%
  layout(title = 'LIWC Summary Analytic on AuthorID in ThreadID X418903', showlegend = T)
p2

# Group by authorID in Thread 3
splittedAuthor3 = split(third, third[3])
head(splittedAuthor3)
length(splittedAuthor3)

c = aggregate(third[7], third[3],mean)
# Pie chart of author ID and analytic
p3 = plot_ly(c, labels = ~X457478.AuthorID, values = ~ X457478.Analytic, type = 'pie', textposition = 'inside', textinfo = 'label+percent')%>%
  layout(title = 'LIWC Summary Analytic on AuthorID in ThreadID 457478', showlegend = T)
p3


### 3.2
# Group by author id to see if they have similar tone in different threads
uniqueAuthor = split(webforum, webforum$AuthorID)

# Get random 10 author ID
sampleAuthor = uniqueAuthor[sample(1:NROW(uniqueAuthor), 10)]
sampleAuthor[1]

by(webforum, webforum$AuthorID, function(df) count(df$ThreadID))

# Top 3 Authors with the most post from the 10 sample 
# First author = 170150
author1 = webforum[webforum$AuthorID == 170150,]
author1 = as.data.frame(author1)
# Second author = 105011
author2 = webforum[webforum$AuthorID == 105011,]
author2 = as.data.frame(author2)
# Third author = 85789
author3 = webforum[webforum$AuthorID == 196102,]
author3 = as.data.frame(author3)

# Get mean of tone in each thread id for each user.
user1 = aggregate(author1[10], author1[2],mean)
user2 = aggregate(author2[10], author2[2],mean)
user3 = aggregate(author3[10], author3[2],mean)

# Add Author ID column
user1['AuthorID'] = 170150
user2['AuthorID'] = 105011
user3['AuthorID'] = 196102

# Combine into 1 data frame
total = rbind(user1,user2,user3)
total
total$AuthorID = as.factor(total$AuthorID)
# Violin plot

violinPlot = ggplot(total, aes(x=total$AuthorID, y=total$Tone, fill = total$AuthorID)) + 
  geom_violin(trim=TRUE) +
  geom_jitter(shape=16,position=position_jitter(0.1)) +
  labs(title="Range of tone by Author ID", x="Author ID",y="Mean of Tone") + 
  scale_fill_manual(values=wes_palette(name="GrandBudapest2")) + 
  theme_classic() +
  theme(legend.position = "none")
violinPlot 


### 4.1
# TIME ANALYSIS
webforum['Year'] = format(as.Date(webforum$Date, format = "%Y-%m-%d"), "%Y")
totalPosemoByYear = aggregate(webforum$posemo~webforum$Year, FUN = mean, data = webforum) 
totalPosemoByYear
totalNegmoByYear = aggregate(webforum$negemo~webforum$Year, FUN = mean, data = webforum)

test = cbind(totalPosemoByYear, totalNegmoByYear[2])
test$`webforum$Year` = as.numeric(test$`webforum$Year`)
dygraph(test, main = "General trend of mean of Positive and Negative emotion in the forum", xlab = "Year", ylab="Mean")%>%
  dySeries("webforum$posemo", label = "Posetive Emotions") %>%
  dySeries("webforum$negemo", label = "Negative Emotions") %>%
  dyRangeSelector(height = 20)

### 4.2
# Number of posts over time
preTest = aggregate(webforum$PostID~webforum$Year,FUN = length, data = webforum)
preTest$`webforum$Year` = as.numeric(preTest$`webforum$Year`)
dygraph(preTest, main = "Number of post per Year", xlab="Year", ylab="Number of Post", col='red')

### 5.0
# Regression
# Posetive and negative emotion on Word count
fit=lm(webforum$WC~ webforum$posemo + webforum$negemo)
summary(fit)

# Anger and swear on clout
fit2=lm(webforum$Clout~ webforum$anger+ webforum$swear)
summary(fit2)

# family and friend on anger
fit2=lm(webforum$anger~ webforum$family+ webforum$friend)
summary(fit2)

# family and friend on postive emotion
fit3 = lm(webforum$posemo~ webforum$family+ webforum$friend)
summary(fit3)