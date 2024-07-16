## python script to downlaod data from CBOP API

import requests
import zipfile
import io
import glob
import json
import os
from datetime import date
today = date.today().strftime("%Y_%m_%d")

## change here
folder = "/home/berenz/data/cbop-api/" + today
folder_ukr = "/home/berenz/data/cbop-api/ukr_" + today

url="https://oferty.praca.gov.pl/integration/services/oferta"
headers = {'content-type': 'text/xml'}


body = """<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:ofer="http://oferty.praca.gov.pl/oferta">
 <soapenv:Header/>
 <soapenv:Body>
 <ofer:Dane>
 <pytanie>
 <Partner>Eko_Uni_Poznan</Partner>
 <Kryterium>
 <Wszystkie>true</Wszystkie>
 </Kryterium>
  </pytanie>
 </ofer:Dane>
 </soapenv:Body>
</soapenv:Envelope>"""

r = requests.post(url,data=body,headers=headers, verify=False)
z = zipfile.ZipFile(io.BytesIO(r.content))
z.extractall(folder + "_oferty/")

result = []
for f in glob.glob(folder + "_oferty/" + "*.json"):
    with open(f, "rb") as infile:
        result.append(json.load(infile))

with open(folder + "_full.json", "wb") as outfile:
     json.dump(result, outfile)

os.system("rm -rf " + folder + "_oferty")


## information about jobs aimed at UKR

body_ukr = """<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:ofer="http://oferty.praca.gov.pl/v2/oferta">
 <soapenv:Header/>
 <soapenv:Body>
 <ofer:Dane>
 <pytanie>
 <Partner>Eko_Uni_Poznan</Partner>
 <Jezyk>ua</Jezyk>
 <Kryterium>
 <Wszystkie>true</Wszystkie>
 </Kryterium>
  </pytanie>
 </ofer:Dane>
 </soapenv:Body>
</soapenv:Envelope>"""

r = requests.post(url,data=body_ukr,headers=headers, verify=False)
z = zipfile.ZipFile(io.BytesIO(r.content))
z.extractall(folder_ukr + "_oferty/")

result = []
for f in glob.glob(folder_ukr + "_oferty/" + "*.json"):
    with open(f, "rb") as infile:
        result.append(json.load(infile))

with open(folder_ukr + "_full.json", "wb") as outfile:
     json.dump(result, outfile)

os.system("rm -rf " + folder_ukr + "_oferty")
