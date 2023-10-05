# This is a script
# to plot maps
# of hate crimes
# in the US

# date: Oct 4th, 2023

# open data


hate_crime_data <- read_csv(file.path(datasets,"hate_crime_data_per_thousands.csv"))

hate_crime_data_state <- hate_crime_data |> 
  group_by(year, fstate) |> 
  summarize(hate_crimes_per_100000 = sum(hate_crimes_per_100000))
table(hate_crime_data_state$state)
# this "states" dataframe has the lat & long info needed for mapping.
states <- st_as_sf(map('state', plot = TRUE, fill = TRUE)) |> 
  rename(state = ID)
states <- states |> 
    mutate(fstate = fips(state))
# join waiting period + lowercase names to df that has lat & long
hate_crime_data_state_sf <- inner_join(hate_crime_data_state, 
                                   states, 
                                   by = "fstate") 
hate_crime_data_state_sf <- st_as_sf(hate_crime_data_state_sf)

# use for loop to plot all maps

for (year_map in seq(1992,2019)) {
  map <- ggplot() + geom_sf(data = hate_crime_data_state_sf |> filter(year == year_map), 
                            aes(fill = `hate_crimes_per_100000`), 
                            color = "white")+
    scale_fill_viridis_c(name = "Legend", option = "turbo") +
    theme_customs_map() +
    labs(title = paste0("Hate Crimes per 100,000 in ", year_map))
  map
  ggsave(path = figures_wd, filename = paste0(year_map,"states_hate_crimes.png"))
#   ggsave(path = thesis_plots, filename = paste0(year_map,"wait.png"))
  
}


# Asian hate Crimes per State

hate_crime_data_state_asian <- hate_crime_data |>
  filter(biasmo1 == 14) 

# this "states" dataframe has the lat & long info needed for mapping.
states <- st_as_sf(map('state', plot = TRUE, fill = TRUE)) |> 
  rename(state = ID)
states <- states |> 
    mutate(fstate = fips(state))
# join waiting period + lowercase names to df that has lat & long
hate_crime_data_state_asian_sf <- inner_join(hate_crime_data_state_asian, 
                                   states, 
                                   by = "fstate") 
hate_crime_data_state_asian_sf <- st_as_sf(hate_crime_data_state_asian_sf)

# use for loop to plot all maps

for (year_map in seq(1992,2019)) {
  map <- ggplot() + geom_sf(data = hate_crime_data_state_asian_sf |> filter(year == year_map), 
                            aes(fill = `hate_crimes_per_100000`), 
                            color = "white")+
    scale_fill_viridis_c(name = "Legend", option = "turbo") +
    theme_customs_map() +
    labs(title = paste0("Anti-Asian Hate Crimes per 100,000 in ", year_map))
  map
  ggsave(path = figures_wd, filename = paste0(year_map,"states_asian_hate_crimes.png"))
#   ggsave(path = thesis_plots, filename = paste0(year_map,"wait.png"))
  
}
