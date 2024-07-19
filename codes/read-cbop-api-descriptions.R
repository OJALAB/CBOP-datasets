library(RcppSimdJson)
library(data.table)
library(lubridate)
library(stringr)

source("codes/functions.R")


# data for 2022 -----------------------------------------------------------

system("tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2022.tar.gz -C /Users/berenz/mac/zbiory/cbop/")

cbop_files <- dir("/Users/berenz/mac/zbiory/cbop/2022", 
                  full.names = T,
                  pattern = "^2022")
## 184
cbop_list <- list()

for (i in 1:NROW(cbop_files)) {
  print(i)
  df <- read_cbop(cbop_files[i], as.Date(str_replace_all(str_extract(cbop_files[i],"\\d{4}_\\d{2}_\\d{2}"), "_", "-")))
  df <- df[, .(poz_kodZawodu, war_stanowisko, war_zakresObowiazkow, war_wyksztalcenia, war_inneWymagania, war_uprawnienia)]
  df[, (names(df)) := lapply(.SD, \(x) str_remove_all(x, "nie dotyczy")), .SDcols = names(df)]
  df[, (names(df)) := lapply(.SD, trimws), .SDcols = names(df)]
  df[, war_stanowisko:=str_remove_all(war_stanowisko, "(^([:punct:]|[\r\n\r])|([:punct:]|[\r\n\r])$)")]
  df[, war_zakresObowiazkow:=str_remove_all(war_zakresObowiazkow, "(^([:punct:]|[\r\n\r])|([:punct:]|[\r\n\r])$)")]
  df[, (names(df)) := lapply(.SD, trimws), .SDcols = names(df)]
  cbop_list[[i]] <- unique(df)
}

cbop <- rbindlist(cbop_list, fill = T)
cbop <- unique(cbop)

system("rm -rf /Users/berenz/mac/zbiory/cbop/2022")

# data for 2023 -----------------------------------------------------------

system("tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2023.tar.gz -C /Users/berenz/mac/zbiory/cbop/")

cbop_files <- dir("/Users/berenz/mac/zbiory/cbop/2023", 
                  full.names = T,
                  pattern = "^2023")


cbop_2023_list <- list()

for (i in 1:NROW(cbop_files)) {
  print(i)
  df <- read_cbop(cbop_files[i], as.Date(str_replace_all(str_extract(cbop_files[i],"\\d{4}_\\d{2}_\\d{2}"), "_", "-")))
  df <- df[, .(poz_kodZawodu, war_stanowisko, war_zakresObowiazkow, war_wyksztalcenia, war_inneWymagania, war_uprawnienia)]
  df[, (names(df)) := lapply(.SD, \(x) str_remove_all(x, "nie dotyczy")), .SDcols = names(df)]
  df[, (names(df)) := lapply(.SD, trimws), .SDcols = names(df)]
  df[, war_stanowisko:=str_remove_all(war_stanowisko, "(^([:punct:]|[\r\n\r])|([:punct:]|[\r\n\r])$)")]
  df[, war_zakresObowiazkow:=str_remove_all(war_zakresObowiazkow, "(^([:punct:]|[\r\n\r])|([:punct:]|[\r\n\r])$)")]
  df[, (names(df)) := lapply(.SD, trimws), .SDcols = names(df)]
  cbop_2023_list[[i]] <- unique(df)
}

cbop_2023 <- rbindlist(cbop_2023_list, fill = T)
cbop_2023 <- unique(cbop_2023)

system("rm -rf /Users/berenz/mac/zbiory/cbop/2023")

# combine data into one dataset -------------------------------------------

cbop_all <- rbind(cbop, cbop_2023)
cbop_all <- unique(cbop_all)


# cleaning and anonimization ---------------------------------------------------
### email address   
email_cols <- c("war_stanowisko", "war_zakresObowiazkow", "war_wyksztalcenia", "war_inneWymagania")
cbop_all[, .N, str_detect(war_stanowisko, "@")] ## 42
cbop_all[, .N, str_detect(war_zakresObowiazkow, "@")] ## 9778
cbop_all[, .N, str_detect(war_wyksztalcenia, "@")] ## 42
cbop_all[, .N, str_detect(war_inneWymagania, "@")] ## 13171

cbop_all[, (email_cols) := lapply(.SD, str_replace_all, 
                                  pattern = "[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+",
                                  replacement = ""), .SDcols = email_cols]



## phone numbers
cbop_all[, (email_cols) := lapply(.SD, str_replace_all, 
                                  pattern = "\\d{3}[ -]?\\d{3}[ -]?\\d{3}",
                                  replacement = ""), .SDcols = email_cols]

cbop_all[, war_wyksztalcenia:=str_remove(war_wyksztalcenia, ", brak$")]

saveRDS(cbop_all, file = "~/mac/zbiory/cbop/cbop-2022-23-occup.rds")


## save to CSV

cbop_all[, desc:=paste(war_stanowisko, war_zakresObowiazkow, war_wyksztalcenia, war_inneWymagania, war_uprawnienia)]
cbop_all[]

fwrite(cbop_all[, .(code = poz_kodZawodu, desc)],
       file = "/Users/berenz/mac/nauka/oja-lab/job-ads-datasets/data/cbop-train-2022-2023-no-employer.tar.gz")
