library(jsonlite)
library(dplyr)

# Read the CSV file
csv_data <- read.csv("data/portal/dim_category.csv", stringsAsFactors = FALSE)

# Remove rows with missing categories or empty data
csv_data <- csv_data[
  !is.na(csv_data$categoria) &
    csv_data$categoria != "missing" &
    csv_data$categoria != "",
]

# Icon mapping for subcategories
icon_mapping <- list(
  "Ônibus" = "onibusIcon.src",
  "Metrô/Trem" = "tremIcon.src",
  "Metrô" = "tremIcon.src",
  "Trem" = "tremIcon.src",
  "Pedestres" = "pedestreIcon.src",
  "Pedestre" = "pedestreIcon.src",
  "BRT" = "brtIcon.src",
  "Bicicleta" = "bicicletaIcon.src",
  "Bicicletas" = "bicicletaIcon.src",
  "VLT" = "vltIcon.src",
  "Monotrilho" = "monotrilhoIcon.src",
  "Aeromóvel" = "aeromovelIcon.src",
  "Vans/Microônibus" = "vanIcon.src",
  "Barco" = "barcoIcon.src",
  "Automóvel" = "carroIcon.src",
  "Táxi" = "taxisIcon.src",
  "Táxis" = "taxisIcon.src",
  "Mototáxi" = "mototaxisIcon.src",
  "Mototáxis" = "mototaxisIcon.src",
  "Trabalhadores" = "trabalhadoresIcon.src",
  "Equipamentos" = "equipamentosIcon.src",
  "Valores" = "valoresIcon.src",
  "Subsídios" = "subsidiosIcon.src",
  "Tributos" = "tributosIcon.src",
  "Multas" = "multasIcon.src",
  "Governança e Leis" = "bandeiraIcon.src",
  "Origem e Destino" = "viagensIcon.src"
)

# Standardize category names to match template
category_mapping <- list(
  "Tarifa" = "Tarifas",
  "Outros" = "Outros"
)

# Process the data
process_csv_to_filter_structure <- function(csv_data) {
  # Clean and standardize data
  csv_data$categoria <- sapply(csv_data$categoria, function(x) {
    if (x %in% names(category_mapping)) {
      return(category_mapping[[x]])
    } else {
      return(x)
    }
  })

  # Handle special subcategory mappings
  csv_data$subcategoria <- case_when(
    csv_data$subcategoria == "Táxi" ~ "Táxis",
    csv_data$subcategoria == "Mototáxi" ~ "Mototáxis",
    csv_data$subcategoria == "Bicicleta" ~ "Bicicletas",
    csv_data$subcategoria == "Pedestres" ~ "Pedestre",
    TRUE ~ csv_data$subcategoria
  )

  # Group by category and subcategory, collecting all labels
  grouped_data <- csv_data %>%
    group_by(categoria, subcategoria) %>%
    summarise(labels = list(label), .groups = 'drop')

  # Create the nested structure
  result <- list()

  for (i in 1:nrow(grouped_data)) {
    cat <- grouped_data$categoria[i]
    subcat <- grouped_data$subcategoria[i]
    labels <- unlist(grouped_data$labels[i])

    if (!(cat %in% names(result))) {
      result[[cat]] <- list()
    }

    # Get icon for subcategory
    icon <- ifelse(
      subcat %in% names(icon_mapping),
      icon_mapping[[subcat]],
      "bandeiraIcon.src"
    ) # default icon

    result[[cat]][[subcat]] <- list(
      icon = icon,
      options = as.list(labels) # Ensure labels are always an array
    )
  }

  return(result)
}

# Generate the filter structure
filter_structure <- process_csv_to_filter_structure(csv_data)

# Get unique icons used
get_unique_icons <- function(structure) {
  icons <- character()
  for (cat in names(structure)) {
    for (subcat in names(structure[[cat]])) {
      icon_var <- gsub("\\.src$", "", structure[[cat]][[subcat]]$icon)
      icons <- c(icons, icon_var)
    }
  }
  return(unique(icons))
}

unique_icons <- get_unique_icons(filter_structure)

# Icon to filename mapping
icon_files <- list(
  "aeromovelIcon" = "aeromovel.svg",
  "bandeiraIcon" = "bandeira.svg",
  "barcoIcon" = "barco.svg",
  "bicicletaIcon" = "bicicleta.svg",
  "brtIcon" = "BRT.svg",
  "carroIcon" = "carro.svg",
  "equipamentosIcon" = "equipamentos.svg",
  "monotrilhoIcon" = "monotrilho.svg",
  "mototaxisIcon" = "mototaxis.svg",
  "multasIcon" = "multas.svg",
  "onibusIcon" = "onibus.svg",
  "pedestreIcon" = "pedestre.svg",
  "subsidiosIcon" = "subsidios.svg",
  "taxisIcon" = "taxis.svg",
  "trabalhadoresIcon" = "trabalhadores.svg",
  "tremIcon" = "trem.svg",
  "tributosIcon" = "tributos.svg",
  "valoresIcon" = "valores.svg",
  "vanIcon" = "van.svg",
  "viagensIcon" = "viagens.svg",
  "vltIcon" = "VLT.svg"
)

# Generate TypeScript content
generate_typescript_content <- function(structure, unique_icons) {
  # Generate imports
  imports <- character()
  for (icon in unique_icons) {
    if (icon %in% names(icon_files)) {
      imports <- c(
        imports,
        sprintf(
          'import %s from "@/app/assets/images/%s"',
          icon,
          icon_files[[icon]]
        )
      )
    }
  }

  # Start building the TypeScript content
  ts_content <- c(
    "// SVG icon imports from assets directory",
    imports,
    "",
    'import { FilterCategoriesType } from "./types"',
    "",
    "// Complete filter categories extracted from CSV data",
    "export const filterCategories: FilterCategoriesType = "
  )

  # Convert structure to JSON and format
  json_structure <- toJSON(structure, pretty = TRUE, auto_unbox = TRUE)

  # Replace quoted icon references with unquoted variables
  for (icon in unique_icons) {
    json_structure <- gsub(
      sprintf('"%s.src"', icon),
      sprintf('%s.src', icon),
      json_structure,
      fixed = TRUE
    )
  }

  # Add the structure and closing
  ts_content <- c(ts_content, json_structure, "")

  return(paste(ts_content, collapse = "\n"))
}

# Generate and write the TypeScript file
typescript_content <- generate_typescript_content(
  filter_structure,
  unique_icons
)
writeLines(typescript_content, "data/portal/filter-categories.ts")

cat("Generated filter-categories.ts successfully!\n")
cat("Categories found:", length(filter_structure), "\n")
cat("Subcategories found:", sum(sapply(filter_structure, length)), "\n")
