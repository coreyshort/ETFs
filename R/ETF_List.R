library(XML)
library(zoo)

url<-"http://etfdb.com/etfdb-categories/"


# get the xml document
doc.html <- htmlTreeParse(url, useInternalNodes = TRUE)

div.class <- "types_inner_first"
div.class2 <- c("types_inner_first", "types_inner", "types_inner_last")
# "types_inner"
# "types_inner_last"

getETFdbCategoryList <- function(doc.html, div.class){
    
    # build xpath for classes and categories from div.class
    id <- c(paste("//div[@class='", div.class ,"']//ul/li/a", sep =  ""),
            paste("//div[@class='", div.class ,"']//h3", sep = "")
            )
    
    # returns a list of headers (asset classes) and categories
    doc.list <- xpathSApply(doc.html, id, xmlValue)
    doc.list = gsub('\\n', '', doc.list)
    doc.list = gsub('\\t','',doc.list)
    doc.list
    
    # identify which items are headers and which are categories
    doc.list2 <- xpathSApply(doc.html, id, xmlName)
    doc.list2
    
    # get the URLs associated with each link
    hrefs <- xpathSApply(doc.html, id, xmlGetAttr, 'href', NA)
    hrefs <- paste("http://etfdb.com", hrefs, sep = "")
    
    df <- as.data.frame(cbind(doc.list2, doc.list, doc.list, hrefs))
    colnames(df) <- c("Type", "Class", "Category", "hrefs")
    
    # add a new column ("Class") with NAs where Type is "a", 
    # and value from Category where Type is "h3"
    df <- within(df, Class[Type != 'h3'] <- NA)
    # fill down Class column
    df$Class <- na.locf(df$Class)
    
    # remove records with 'h3' in Type
    df <- df[which(df$Type != 'h3'), ]
    
    # drop Type column
    df$Type <- NULL

   return(df)
}

