# data-pemob

Pipeline em R para processamento e publicação dos dados da PEMOB
(Pesquisa de Mobilidade Urbana) no Portal das Cidades.

## Estrutura

- `R/` — scripts de processamento
  - `pemob.R`, `pemob_final.R` — pipeline principal (municipal)
  - `pemob_metropolitana.R` — pipeline regiões metropolitanas
  - `pemob_portal.R`, `pemob_portal_final.R` — preparação dos arquivos
    JSON consumidos pelo portal
  - `pemob_data_portal.R`, `amostra_dashboard.R` — exportações auxiliares
  - `pemob_errors.R` — utilitários de validação
- `data-raw/` — dados brutos PEMOB (2019–2025, municipal e metropolitana)
- `data/` — dicionários, categorias e arquivos derivados
  - `portal/v1/` — JSONs anuais publicados no portal
- `tabelas/` — tabelas de referência (códigos, harmonização)
- `generate_filter_categories.R` — geração das categorias de filtros do portal

## Saídas do portal

`data/portal/v1/pemob_<ano>.json` (2019–2024) são os artefatos consumidos
pelo frontend do Portal das Cidades.

## Notas

- Arquivos grandes (`.xlsx`, CSVs harmonizados completos) ficam fora do
  controle de versão — ver `.gitignore`.
- Projeto RStudio: abrir `simu_pemob.Rproj`.
