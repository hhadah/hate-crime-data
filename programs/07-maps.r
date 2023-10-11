# This is a script
# to plot maps
# of hate crimes
# in the US

# date: Oct 4th, 2023

# open data


hate_crime_data <- read_csv(file.path(datasets,"anti-asian-hatecrime-bystate-mergeCPS.csv"))

# this "states" dataframe has the lat & long info needed for mapping.
states <- st_as_sf(map('state', plot = TRUE, fill = TRUE)) |> 
  rename(state = ID)
states <- states |> 
    mutate(fstate = fips(state))
# join waiting period + lowercase names to df that has lat & long
hate_crime_data_sf <- inner_join(hate_crime_data, 
                                   states, 
                                   by = "fstate") 
hate_crime_data_sf <- st_as_sf(hate_crime_data_sf)

# use for loop to plot all maps

for (year_map in seq(1,9)) {
  map <- ggplot() + geom_sf(data = hate_crime_data_sf |> filter(year_group == year_map), 
                            aes(fill = `hate_crimes_per_100000`), 
                            color = "white")+
    scale_fill_viridis_c(name = "Legend", option = "turbo") +
    theme_customs_map() +
    labs(title = paste0("Anti-Asian Hate Crimes per 100,000 in Year Group", year_map))
  map
  ggsave(path = figures_wd, filename = paste0(year_map,"states_asian_hate_crimes.png"))
#   ggsave(path = thesis_plots, filename = paste0(year_map,"wait.png"))
  
}


