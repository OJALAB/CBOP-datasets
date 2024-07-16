# Bash processing

## files for 2021
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2021.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2021/2021_03_31_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2021.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2021/2021_06_30_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2021.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2021/2021_09_30_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2021.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2021/2021_12_31_full.json

## files for 2022
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2022.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2022/2022_03_31_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2022.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2022/2022_06_30_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2022.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2022/2022_09_30_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2022.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2022/2022_12_31_full.json

## files for 2023
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2023.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2023/2023_03_31_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2023.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2023/2023_06_30_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2023.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2023/2023_09_30_full.json
tar -zxvf /Users/berenz/mac/zbiory/cbop/cbop-2023.tar.gz -C /Users/berenz/mac/zbiory/cbop/ ./2023/2023_12_31_full.json

mkdir /Users/berenz/mac/zbiory/cbop/end-of-quarters
mv /Users/berenz/mac/zbiory/cbop/2020/*.json /Users/berenz/mac/zbiory/cbop/end-of-quarters/
mv /Users/berenz/mac/zbiory/cbop/2021/*.json /Users/berenz/mac/zbiory/cbop/end-of-quarters/
mv /Users/berenz/mac/zbiory/cbop/2022/*.json /Users/berenz/mac/zbiory/cbop/end-of-quarters/
mv /Users/berenz/mac/zbiory/cbop/2023/*.json /Users/berenz/mac/zbiory/cbop/end-of-quarters/
