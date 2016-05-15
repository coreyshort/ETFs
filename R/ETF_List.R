
url<-"http://etfdb.com/etfdb-categories/"
library(XML)

# get the xml document
doc.html<-htmlTreeParse(url, useInternalNodes = TRUE)


getETFdbCategoryList <- function(doc.html, div.class){}

# returns a list of headers (asset classes) and categories
id <- c("//div[@class='types_inner_first']//ul/li/a","//div[@class='types_inner_first']//h3")
doc.list<-xpathSApply(doc.html, id, xmlValue)
doc.list = gsub('\\n', '', doc.list)
doc.list = gsub('\\t','',doc.list)
doc.list

# identify which items are headers and which are categories
doc.list2<-xpathSApply(doc.html, id, xmlName)
doc.list2

# get the URLs associated with each link
hrefs <- xpathSApply(doc.html, id, xmlGetAttr, 'href', NA)
hrefs
unlist(hrefs)

doc.head<-xpathSApply(doc.html, "//div[@class='types_inner_first']//h3", xmlValue)
doc.head


