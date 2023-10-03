# read hate crime data
# and clean them

# data: October 2nd, 2023

tsv_files <- dir_ls(path = raw,
                    glob = "*0002-Data.tsv$",
                    type = "file",
                    recurse = TRUE)
# Define column types
col_types <- cols(
  OFFCOD3   = col_character(),
  CFIPS3    = col_character(),  # Ensuring CFIPS3 is also read as character
  OFFCOD4   = col_character(),
  CFIPS2    = col_character(),
  CFIPS1    = col_character()
)

# Read each TSV file with specified column types and concatenate them together
all_data <- map_df(tsv_files, ~read_tsv(.x, col_types = col_types))

# Convert column names to lowercase
colnames(all_data) <- tolower(colnames(all_data))


# rename columns
all_data <- all_data %>%
  rename(
    record_type     = rec_ir,
    state           = statnum,
    agency          = ori,
    date_crime      = inciddte,
    year            = masteryr,
    countyfips      = cfips1,
  ) |> 
  arrange(year, state, agency, date_crime)
