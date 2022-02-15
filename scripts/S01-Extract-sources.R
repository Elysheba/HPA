library(RJSONIO)
library(RSQLite)
library(stringr)
library(here)
source(here("../00-Utils/downloadSourceFiles.R"))

desc <- readJSONStream(here("DESCRIPTION.json"))

sourceFiles <- desc$"source files"
urls <- unlist(lapply(
   sourceFiles,
   function(sf){
      toRet <- sf$"URL template"
      names(toRet) <- sf$"name"
      return(toRet)
   }
))


########################################################
## Download sqlite db    
# urls[paste(version, "sqlite.tar.gz", sep = "_")] <- sprintf(
#    urls[paste(version, "sqlite.tar.gz", sep = "_")],
#    format(Sys.Date(), "%Y-%m")
# )
# srcDir <- "../sources"

# downloadSourceFiles(urls, srcDir)

