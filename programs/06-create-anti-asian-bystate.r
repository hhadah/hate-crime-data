# This is a script
# to create anti-asian 
# hate crimes by state
# to merge with CPS

# date: Oct 10th, 2023

# open data


hate_crime_data <- read_csv(file.path(datasets,"hate_crime_data_per_thousands.csv"))

hate_crime_data <- hate_crime_data |> 
    mutate(year_group = case_when(
                        year >= 1994 & year <= 1996 ~ 1,
                        year >= 1997 & year <= 1999 ~ 2,
                        year >= 2000 & year <= 2002 ~ 3,
                        year >= 2003 & year <= 2005 ~ 4,
                        year >= 2006 & year <= 2008 ~ 5,
                        year >= 2009 & year <= 2011 ~ 6,
                        year >= 2012 & year <= 2014 ~ 7,
                        year >= 2015 & year <= 2017 ~ 8,
                        year >= 2018 & year <= 2020 ~ 9))

hate_crime_data_state <- hate_crime_data |> 
  filter(biasmo1 == 14) |> 
  group_by(year_group, fstate) |> 
  summarize(hate_crimes_per_100000 = sum(hate_crimes_per_100000),
            hate_crimes = sum(hate_crimes))

write_csv(hate_crime_data_state, file.path(datasets, "anti-asian-hatecrime-bystate-mergeCPS.csv"))
