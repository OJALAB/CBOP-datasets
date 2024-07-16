## Codes to read the CBOP data from JSON files

library(RcppSimdJson)
library(data.table)
library(lubridate)
library(stringr)


source("codes/functions.R")

cbop_files <- dir("/Users/berenz/mac/zbiory/cbop/end-of-quarters", full.names = T)

suppressWarnings(
  cbop <- lapply(cbop_files, 
                 \(x) read_cbop(x, as.Date(str_replace_all(str_extract(x,"\\d{4}_\\d{2}_\\d{2}"), "_", "-"))))
)

cbop <- rbindlist(cbop, fill = T)

data.table::fwrite(cbop, file = "~/mac/zbiory/cbop/cbop-2021-2023.csv.gz", quote = T)

