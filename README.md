# 370-Exploring-Data-In-R

This was a lab assignment for my Introduction to Data Science course focusing in R. The learning objectives were the following:

	Creating basic graphs and data summaries in R
	Wrangling data > 1 GB
	Validating data (e.g., unique identifiers)

We were provided two massive data files, combined were roughly 1.2-1.3 GB files and were asked to process them and pull information from them using R. I am very comfortable using SQL, so I used an R library called "sqldf" to filter the data with sql-like queries but instead of using database tables, I used R dataframes and tables to run queries. I also used a library called "stringr" since I like how python allows you to get the last n characters or values using the '-' symbol.

The questions we were asked are the following:

	1.What is the correct ID in the links table?
	2.What is the most cited paper in PubMed? Provide title, year and journal
	3. What is the most cited journal in PubMed?
	4. Show histogram of citations by year?
	5. Number of citations over time
