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

# create hate crime dataset by
# county, state, year, and hate crime type

hate_crime_data <- all_data  |> 
  group_by(state, year, biasmo1) |>
  summarise(
    hate_crimes = n()
  )

average_over_time <- all_data  |> 
  group_by(year, biasmo1) |>
  summarise(
    hate_crimes = n()
  )

# create a variable for
# the state's fips code
ucr_to_fips <- function(ucr_code) {
    ucr_to_fips_map <- list(
        '1' = '01',  # Alabama
        '2' = '04',  # Arizona
        '3' = '05',  # Arkansas
        '4' = '06',  # California
        '5' = '08',  # Colorado
        '6' = '09',  # Connecticut
        '7' = '10',  # Delaware
        '8' = '11',  # District of Columbia
        '9' = '12',  # Florida
        '10' = '13', # Georgia
        '11' = '16', # Idaho
        '12' = '17', # Illinois
        '13' = '18', # Indiana
        '14' = '19', # Iowa
        '15' = '20', # Kansas
        '16' = '21', # Kentucky
        '17' = '22', # Louisiana
        '18' = '23', # Maine
        '19' = '24', # Maryland
        '20' = '25', # Massachusetts
        '21' = '26', # Michigan
        '22' = '27', # Minnesota
        '23' = '28', # Mississippi
        '24' = '29', # Missouri
        '25' = '30', # Montana
        '26' = '31', # Nebraska
        '27' = '32', # Nevada
        '28' = '33', # New Hampshire
        '29' = '34', # New Jersey
        '30' = '35', # New Mexico
        '31' = '36', # New York
        '32' = '37', # North Carolina
        '33' = '38', # North Dakota
        '34' = '39', # Ohio
        '35' = '40', # Oklahoma
        '36' = '41', # Oregon
        '37' = '42', # Pennsylvania
        '38' = '44', # Rhode Island
        '39' = '45', # South Carolina
        '40' = '46', # South Dakota
        '41' = '47', # Tennessee
        '42' = '48', # Texas
        '43' = '49', # Utah
        '44' = '50', # Vermont
        '45' = '51', # Virginia
        '46' = '53', # Washington
        '47' = '54', # West Virginia
        '48' = '55', # Wisconsin
        '49' = '56', # Wyoming
        '50' = '02', # Alaska
        '51' = '15'  # Hawaii
    )
    
    if (ucr_code %in% names(ucr_to_fips_map)) {
        return(as.numeric(ucr_to_fips_map[[as.character(ucr_code)]]))
    } else {
        return(NA_real_) # returning NA_real_ to keep the datatype as numeric
    }
}

# Apply this function to a dataframe with column named `state`
hate_crime_data$fstate <- sapply(hate_crime_data$state, ucr_to_fips)
hate_crime_data <- hate_crime_data |>
  filter(state < 55 | !is.na(state))
table(hate_crime_data$fstate)
# save data
write_csv(hate_crime_data, file.path(datasets, "hate_crime_data.csv"))
write_csv(average_over_time, file.path(datasets, "average_over_time.csv"))
