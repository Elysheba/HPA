library(XML)
library(parallel)
library(RSQLite)
library(stringr)
library(BED)
library(here)
library(ReDaMoR)
library(dplyr)
library(readr)
library(readxl)
library(reshape2)
library(tidyr)
library(TKCat)

###############################################################################@
## Make data model
###############################################################################@
load(here("model/HPA.rda"))
# dm <- ReDaMoR::model_relational_data(dm)
# save(dm, file = here("model/HPA.rda"))

###############################################################################@
## Load files
###############################################################################@
gene_brain_enhanced <- readr::read_tsv(here("sources/gene_brain_enhanced.tsv")) %>% 
  select(Gene, Ensembl, Uniprot, 
         `Protein class`, `Biological process`, 
         `Molecular function`, `RNA tissue specificity`,
         `RNA tissue distribution`, `RNA brain regional specificity`,
         `RNA brain regional distribution`, `Subcellular location`,
         `Secretome location`, `Subcellular main location`, 
         `Subcellular additional location`) %>% 
  mutate(type = "brain_enhanced_expression")
gene_brain_enriched <- readr::read_tsv(here("sources/gene_brain_enriched.tsv")) %>% 
  select(Gene, Ensembl, Uniprot, 
         `Protein class`, `Biological process`, 
         `Molecular function`, `RNA tissue specificity`,
         `RNA tissue distribution`, `RNA brain regional specificity`,
         `RNA brain regional distribution`, `Subcellular location`,
         `Secretome location`, `Subcellular main location`, 
         `Subcellular additional location`) %>% 
  mutate(type = "brain_enriched_expression")
gene_brain_specific <- readr::read_tsv(here("sources/gene_brain_specific.tsv")) %>% 
  select(Gene, Ensembl, Uniprot, 
         `Protein class`, `Biological process`, 
         `Molecular function`, `RNA tissue specificity`,
         `RNA tissue distribution`, `RNA brain regional specificity`,
         `RNA brain regional distribution`, `Subcellular location`,
         `Secretome location`, `Subcellular main location`, 
         `Subcellular additional location`) %>% 
  mutate(type = "brain_specific_expression")
HPA_gene_brain_expression <- bind_rows(gene_brain_enhanced,
                                       gene_brain_enriched,
                                       gene_brain_specific)

HPA_protein_atlas <- read_tsv(unzip(zipfile = here("sources/proteinatlas.tsv.zip")))
HPA_protein_atlas <- HPA_protein_atlas %>% 
  select(Gene, Ensembl, Uniprot, 
         `Protein class`, `Biological process`, 
         `Molecular function`, `RNA tissue specificity`,
         `RNA tissue distribution`, `RNA brain regional specificity`,
         `RNA brain regional distribution`, `Subcellular location`,
         `Secretome location`, `Subcellular main location`, 
         `Subcellular additional location`) 


###############################################################################@
## Writing tables ----
###############################################################################@
message("Writing tables...")
message(Sys.time())
toSave <- grep("^HPA[_]", ls(), value=T)
for(f in toSave){
  message(paste("Saving", f))
  ## Ensure unicity
  assign(f, get(f))
  if(length(names(f))==0){
    f <- unique(f)
  }
  ##
  write.table(
    get(f),
    file=here("data", paste(f, ".txt", sep="")),
    sep="\t",
    row.names=FALSE, col.names=TRUE,
    quote=TRUE,
    qmethod = "double"
  )
}
message(Sys.time())
message("... Done\n")
