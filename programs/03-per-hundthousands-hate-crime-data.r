
# This script is used to calculate 
# the per 100,000 population 
# for hate crimes

# Data: October 4th, 2023

# Open ACS data

ACS <- fread(ACS_path)
ACS <- as.data.frame(ACS)
# Clean Data
# Calculate US Populations 
us_population <- ACS %>% 
  group_by(YEAR) %>% 
  summarise(Population = sum(PERWT)) |> 
  mutate(merge_year = YEAR)

# Calculate Populations 
Population <- ACS %>% 
  group_by(YEAR, STATEFIP) %>% 
  summarise(Population = sum(PERWT)) |> 
  mutate(merge_year = YEAR) |> 
  rename(fstate = STATEFIP)

# Open Hate Crime Data
hate_crime_data <- read_csv(file.path(datasets,"hate_crime_data.csv")) |> 
    mutate(merge_year = case_when(year < 2000 ~ 1990,
                                  year >= 2000 & year < 2010 ~ 2000,
                                  year >= 2010 ~ 2010),
                                )
# US hate crime
hate_crime_data_us  <- hate_crime_data |> 
    group_by(year, biasmo1) |> 
    summarise(hate_crimes = sum(hate_crimes, na.rm = T))
hate_crime_data_us  <- hate_crime_data_us |>   
    mutate(merge_year = case_when(year < 2000 ~ 1990,
                                  year >= 2000 & year < 2010 ~ 2000,
                                  year >= 2010 ~ 2010),
                                )

# merge state population with
# state hate crime data
table(hate_crime_data$state)
table(hate_crime_data$fstate)

table(Population$state)

state_year <- left_join(
  hate_crime_data,
  Population,
  na_matches = "never",
  by = c("merge_year", "fstate")
)
state_year |> 
    glimpse()

state_year <- state_year |> 
    mutate(hate_crimes_per_100000 = hate_crimes / Population * 100000)
table(state_year$state)
table(state_year$fstate)

write_csv(state_year, file.path(datasets, "hate_crime_data_per_thousands.csv"))

# merge US population with
# US hate crime data
US_year <- left_join(
  hate_crime_data_us,
  us_population,
  na_matches = "never",
  by = c("merge_year")
)
US_year |> 
    glimpse()

US_year <- US_year |> 
    mutate(hate_crimes_per_100000 = hate_crimes / Population * 100000)
write_csv(US_year, file.path(datasets, "US_hate_crime_data_per_thousands.csv"))
