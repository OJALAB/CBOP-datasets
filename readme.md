# Repository to read the data from CBOP

## What is CBOP

-   CBOP stands for [Centalna Baza Ofert Pracy](https://oferty.praca.gov.pl/portal/index.cbop) which is a database of job vacancies submitted to Public Employment Offices.
-   CBOP can be accessed from official API which allows to download adds in JSON format. Details can be found [here](https://oferty.praca.gov.pl/portal/index.cbop#/dlaInt).
-   description of the columns can be found [here](https://oferty.praca.gov.pl/portal/instrukcja_pobierania_wydarzen_z_cbop.pdf) and [here](docs/pol-api-manual-2024.pdf)
-   data contains 174 variables on:
    -   Working and pay conditions
            - Description of the requirements necessary for the job (55-64)
            - Description of desirable requirements to perform the job. (65-74)
            - Requirements to perform the job (75-84)
    -   Employer data
    -   Other data

## What is in this repository

-   this repository contains codes to read JSON files from the API
-  structure:
    + `codes`:
        + `read-cbop-api.R` -- main file to read the CBOP data in
        + `functions.R` -- file with the function to read the data in
        + `cbop-api-download.py` -- Python code to obtain data from the CBOP API
        + `cbop-zip-files.sh` -- some bash processing (not for reading)
    + `docs`: 
        + `pol-api-manual-2024.pdf` -- description of the data

## Funding

### NAWA
Research funded by the Polish National Agency for Academic Exchange (NAWA) under The Bekker NAWA Programme, grant number BPN/BEK/2023/1/00099/U/00001 (visit at University of Manchester between 01.06 and 31.08.2024).

[![](docs/logo-nawa.png)](https://nawa.gov.pl/en/)
