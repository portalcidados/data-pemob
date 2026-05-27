# PEMOB

Pipeline em R para processamento, harmonização e publicação dos dados da PEMOB
(Pesquisa Nacional de Mobilidade Urbana).

## Estrutura

- `R/` — scripts de processamento
  - `pemob.R`, `pemob_final.R` — pipeline principal (municipal)
  - `pemob_metropolitana.R` — pipeline regiões metropolitanas
  - `pemob_portal.R` — preparação dos arquivos
    JSON consumidos pelo portal
  - `pemob_errors.R` — utilitários de validação
- `data-raw/` — dados brutos PEMOB (2019–2025, municipal e metropolitana)
- `data/` — dicionários, categorias e arquivos derivados
- `tabelas/` — tabelas de referência (códigos, harmonização)

## Saídas do portal

`data/portal/v1/pemob_<ano>.json` (2019–2024) são os artefatos consumidos
pelo frontend do Portal das Cidades.

## Notas

- Arquivos grandes (`.xlsx`, CSVs harmonizados completos) ficam fora do
  controle de versão — ver `.gitignore`.
- Projeto RStudio: abrir `simu_pemob.Rproj`.

## Próximos passos

- Incorporar dados da pesquisa de 2025
- Pipeline para dataset Metropolitano
- Refatorar código e usar {renv}
