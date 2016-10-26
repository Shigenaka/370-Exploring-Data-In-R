#Mason Shigenaka
#Set the correct directory depending on the location of the txt files
#setwd("/Users/MasonShigenaka/Desktop/INFO 370")
setwd("/Users/iguest/Desktop/370 Lab 3")

#Clean Directory
rm(list=ls(all=TRUE))

#Download/set up sqldf lib
install.packages("sqldf")
library(sqldf)

#Download/install stringr package
install.packages("stringr")
library(stringr)

#Create two data structures that read in the .txt files
links <- read.table("pubmed_links_INFO370.txt", header = TRUE, sep = "", fill=FALSE, strip.white=TRUE) #Should be 16004596
#Set fill=TRUE because there are numerous rows with less than five entires, line 1732238+1 (because of removed header) is one example
nodes <- read.table("pubmed_nodes_INFO370.txt", header = TRUE, sep="\t", quote="", na.strings = "NULL", fill=TRUE, strip.white=TRUE, comment="") #Should be 5538323
nodes$pmid = as.integer(as.character(nodes$pmid))

#1. What is the correct ID in the links table?
head(links, 1)
sqldf("select pmid from nodes join links on nodes.pmid = links.cited where links.cited = nodes.pmid")
#Answer: pmid

#2. What is the most cited paper in PubMed? Provide title, year and journal
mostCited <- tail(names(sort(table(links$cited))), 1)
mostCitedPaper <- fn$sqldf('select pmid, title from nodes where nodes.pmid = $mostCited')
#Answer:Basic local alignment search tool

#3. What is the most cited journal in PubMed?
citationsJournal <- sqldf("SELECT l.cited, n.journal
                   FROM links l
                   JOIN nodes as n on n.pmid = l.cited")
citationsJournal <- citationsJournal[complete.cases(citationsJournal), ]
mostCitedJournal <- sqldf("SELECT journal, COUNT(*) as NumCited
                          FROM citationsJournal
                          GROUP BY journal
                          ORDER BY NumCited DESC
                          LIMIT 1")
#Answer: PLOS One

#4. Show histogram of citations by year
citations <- sqldf("SELECT l.cited, n.date_pub
                   FROM links l
                   JOIN nodes as n on n.pmid = l.cited
                   WHERE n.pmid = l.cited")
citationYear <- str_sub(as.character(citations$date_pub), start = -4)
citationYear <- as.numeric(citationYear)
citationYear <- citationYear[!is.na(citationYear)]
hist(citationYear, main = "Histogram of Citations by Year", xlim = range(1950, 2016)) #added breaks to try to make it show more values

#5. Number of citations over time (Line/Bar)
citationCiting <- sqldf("SELECT n.date_pub
                        FROM links l
                        JOIN nodes as n on n.pmid = l.citing")
citationCiting$date_pub <- str_sub(as.character(citationCiting$date_pub), start = -4)
citationCiting$date_pub <- as.numeric(citationCiting$date_pub)

citationYearGroup <- sqldf("SELECT date_pub, count(*) as freq
                           FROM citationCiting
                           GROUP BY date_pub
                           ORDER BY date_pub ASC")
citationYearGroup <- citationYearGroup[complete.cases(citationYearGroup), ]
plot(citationYearGroup$date_pub, cumsum(citationYearGroup$freq), type = "l")
