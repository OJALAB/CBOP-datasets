
# function for reading JSON files -----------------------------------------

## arguments:
## file - json file
## quarter 
read_cbop <- function(file, qdata, verbose = TRUE) {
  
  ## helper functions
  regon_check <- function(x, last, digits = 9) {
    
    if (digits == 9) {
      regon_weights <- c(8,9,2,3,4,5,6,7) ## mod 11
      splitted <- as.numeric(str_split(x, "", simplify = T)[1:8])
      mod <- sum(splitted*regon_weights) %% 11
      if (mod == 10) mod <- 0
      test <- mod %% 11 == last
    } else {
      regon_weights <- c(2,4,8,5,0,9,7,3,6,1,2,4,8) ## mod 11
      splitted <- as.numeric(str_split(x, "", simplify = T)[1:13])
      mod <- sum(splitted*regon_weights) %% 11
      if (mod == 10) mod <- 0
      test <- mod %% 11 == last
    }
    return(test)
  }
  
  regon_check_vec <- Vectorize(regon_check, vectorize.args = c("x", "last"))
  
  nip_check <- function(x, last) {
    nip_weights <- c(6, 5, 7, 2, 3, 4, 5, 6, 7) ## mod 11
    splitted <- as.numeric(str_split(x, "", simplify = T)[1:9])
    mod <- sum(splitted*nip_weights) %% 11
    test <- mod %% 11 == last
    return(test)
  }
  
  nip_check_vec <- Vectorize(nip_check, vectorize.args = c("x", "last"))
  

  cbop_file <- readLines(file)
  cbop_file <- RcppSimdJson::fparse(json = cbop_file[1])
  
  prac_list <- list()
  for (i in 1:length(cbop_file)) {
    ## employeer information
    prac <- cbop_file[[i]]$danePracodawcy
    names(prac) <- cbop_file[[i]]$hash
    prac_df <-  rbindlist(prac, idcol = "hash")
    setnames(prac_df, names(prac_df)[-1], paste0("prac_", names(prac_df)[-1]))
    
    ## other information
    pozostaleDane <- rbindlist(cbop_file[[i]]$pozostaleDane)
    setnames(pozostaleDane, names(pozostaleDane), paste0("poz_", names(pozostaleDane)))
    
    ## Working and pay conditions
    warunkiPracyIPlacy <- lapply(cbop_file[[i]]$warunkiPracyIPlacy, as.data.table)
    warunkiPracyIPlacy <- lapply(warunkiPracyIPlacy, \(x) x[1,])
    warunkiPracyIPlacy <- rbindlist(warunkiPracyIPlacy, fill = T)
    setnames(warunkiPracyIPlacy, names(warunkiPracyIPlacy), paste0("war_", names(warunkiPracyIPlacy)))
    
    prac_df <- cbind(prac_df, pozostaleDane, warunkiPracyIPlacy)
    
    prac_df[, ":="(typOferty = cbop_file[[i]]$typOferty,
                   typOfertyNaglowek = cbop_file[[i]]$typOfertyNaglowek,
                   zagranicznaEures = cbop_file[[i]]$zagranicznaEures,
                   kodJezyka =  cbop_file[[i]]$kodJezyka,
                   czyWazna = cbop_file[[i]]$czyWazna,
                   statusOferty = cbop_file[[i]]$statusOferty,
                   zaintUA = if (is.null(cbop_file[[i]]$pracodZainteresZatrUA)) NA else cbop_file[[i]]$pracodZainteresZatrUA,
                   tlumUA = if (is.null(cbop_file[[i]]$zgodNaTlumaczenieUA)) NA else cbop_file[[i]]$zgodNaTlumaczenieUA)]
    prac_list[[i]] <- prac_df
  }
  
  prac_list_df <- rbindlist(prac_list, fill = T)

  ### internal data cleaning
  if (verbose) {
    print("Number of rows:", nrow(prac_list_df))
  }
  prac_list_df[, ":="(poz_dataPrzyjZglosz=dmy(poz_dataPrzyjZglosz),
                      poz_ofertaWaznaDo=dmy(poz_ofertaWaznaDo))]
  
  final_df <- prac_list_df[, ":="(prac_nip = str_remove_all(prac_nip, "-"),
                                  poz_dni = qdata-poz_dataPrzyjZglosz,
                                  kod_pocztowy = str_extract(war_miejscePracy, "\\d{2}\\-\\d{3}"))]
  
  final_df[prac_pracodawca == "kontakt przez PUP", prac_pracodawca:=NA]
  final_df[prac_pracodawca == "kontakt przez OHP", prac_pracodawca:=NA]
  
  final_df[, ":="(war_gmina = tolower(war_gmina), war_ulica=tolower(war_ulica), war_miejscowosc=tolower(war_miejscowosc))]
  final_df[, ":="(war_gmina = str_remove(war_gmina, "m.st. "))]
  final_df[, prac_nip := str_remove_all(prac_nip, "-")]
  final_df[, war_ulica:=str_replace(war_ulica,  "pl\\.", "plac ")]
  final_df[, war_ulica:=str_replace(war_ulica,  "al\\.", "aleja ")]
  final_df[, war_ulica:=str_replace(war_ulica,  "  ", " ")]
  final_df[, war_ulica:=str_remove(war_ulica,  "^\\.|-$")]
  final_df[, kod_pocztowy:=str_remove(kod_pocztowy, "00-000")]
  final_df[kod_pocztowy == "", kod_pocztowy := NA]
  final_df[, poz_kodZawodu := str_remove(poz_kodZawodu, "RPd057\\|")]
  final_df[, qdata:=qdata]
  
  final_df[, row_id := 1:.N] ## row identifiers
  final_df[, prac_regon:=str_extract(prac_regon, "\\d{1,}")] ## remove non-numbers
  final_df[, prac_nip:=str_extract(prac_nip, "\\d{1,}")] ## ## remove non-numbers
  final_df[str_detect(prac_nip, "^([0-9])\\1*$"), prac_nip := NA] ## if all numbers are the same -- NA
  final_df[str_detect(prac_regon, "^([0-9])\\1*$"), prac_regon := NA] ## if all numbers are the same -- NA
  final_df[nchar(prac_regon) == 14 & str_detect(prac_regon, "00000$"), prac_regon:=substr(prac_regon,1,9)] ## correct number of digits
  final_df[nchar(prac_regon) == 10 & prac_regon == prac_nip, prac_regon := NA] ## regon the same as np 
  final_df[nchar(prac_regon) %in% c(3,10), prac_regon := NA] ## incorrect numbers
  final_df[nchar(prac_regon) == 8, prac_regon := str_pad(prac_regon, 9, "left", "0")] ## add leading zeros
  final_df <- final_df[!is.na(prac_regon) | !is.na(prac_nip)] ## remove missing in both identifiers
  final_df[!is.na(prac_nip), regon9_count:=uniqueN(substr(prac_regon[!is.na(prac_regon)],1,9)), prac_nip] ## count unique regons in ni
  final_df[!is.na(prac_regon), regon9_count:=uniqueN(prac_nip), prac_regon] ## count unique nip byu regons
  final_df[nchar(prac_regon) == 9, regon9_last_dig:=substr(prac_regon, 9,9)]
  final_df[nchar(prac_regon) == 14, regon14_last_dig:=substr(prac_regon, 14,14)]
  final_df[nchar(prac_nip) == 10, nip_last_dig:=substr(prac_nip, 10,10)]
  final_df[nchar(prac_regon) == 9, regon9_check:=regon_check_vec(prac_regon, as.numeric(regon9_last_dig))] # 646 in regon 9 digits
  final_df[nchar(prac_regon) == 14, regon14_check:=regon_check_vec(prac_regon, as.numeric(regon14_last_dig), 14)] # 30 in regon 14 digits
  final_df[nchar(prac_nip) == 10, nip_check:=nip_check_vec(prac_nip, as.numeric(nip_last_dig))] # NIPs are correct!
  final_df[regon9_check == FALSE, prac_regon := NA]
  final_df[regon14_check == FALSE, prac_regon := NA]
  
  ## Polish JVS definition
  final_df[typOferty == "OFERTA_PRACY" & czyWazna == TRUE & 
             as.Date(poz_dataPrzyjZglosz) <= qdata & as.Date(poz_ofertaWaznaDo) >= qdata & 
             war_kraj == "Polska" &
             !war_rodzajZatrudnienia %in% c("Praktyka absolwencka", "Nie dotyczy", "Umowa zlecenie / Umowa o świadczenie usług", "Umowa o dzieło",
                                            "Umowa agencyjna") & 
             zagranicznaEures == FALSE & 
             str_detect(war_stanowisko, regex("staż|praktyk", T), negate = T) & 
             (str_extract(war_wynagrodzenieBrutto, "[A-Z]{3}") %in% c("PLN", NA)), jvs_vac_def := TRUE]
  
  return(final_df[!is.na(prac_regon) | !is.na(prac_nip)])
}


