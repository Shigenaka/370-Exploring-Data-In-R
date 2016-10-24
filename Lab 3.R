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
nodes$date_pub = strftime(as.character(nodes$date_pub),  format = "%Y-%m-%d", tz = "")

#1. What is the correct ID in the links table?
head(links, 1)
sqldf("select pmid from nodes join links on nodes.pmid = links.cited where links.cited = nodes.pmid")
#Answer: pmid

#2. What is the most cited paper in PubMed? Provide title, year and journal
mostCited <- tail(names(sort(table(links$cited))), 1)
mostCitedPaper <- fn$sqldf('select pmid, title, date_pub from nodes where nodes.pmid = $mostCited')
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
citations <- sqldf("SELECT l.citing, n.date_pub
                   FROM links l
                   JOIN nodes as n on n.pmid = l.citing
                   WHERE n.pmid = l.citing")
citationYear <- str_sub(as.character(citations$date_pub), start = -4)
citationYear = as.integer(citationYear)
hist(citationYear)

#5. Number of citations over time (Line/Bar)
citationYearDF <- data.frame(citationYear, row.names = "year")
citationYearGroup <- sqldf("SELECT citationYear, count(*) as freq
                           FROM citationYearDF
                           GROUP BY citationYear
                           ORDER BY citationYear ASC")
citationYearGroup <- citationYearGroup[complete.cases(citationYearGroup), ]
plot(citationYearGroup$citationYear, cumsum(citationYearGroup$freq), type = "l")
