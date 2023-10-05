# This is a script
# to plot some graphs
# of suicide data in
# in the US

# date: July 26th, 2022

# open data

hate_crime_data <- read_csv(file.path(datasets,"hate_crime_data_per_thousands.csv"))
US_hate_crime_data <- read_csv(file.path(datasets,"US_hate_crime_data_per_thousands.csv"))

# function to convert numerical
# value of hate crime type
# to text

convert_to_crime_type <- function(biasmo1) {
  # Create a named vector for mapping
  crime_types <- c(
    "11" = "Anti-White",
    "12" = "Anti-Black",
    "13" = "Anti-Am Indian",
    "14" = "Anti-Asian",
    "15" = "Anti-Multi-Racial",
    "21" = "Anti-Jewish",
    "22" = "Anti-Catholic",
    "23" = "Anti-Protestant",
    "24" = "Anti-Islamic",
    "25" = "Anti-Other Religion",
    "26" = "Anti-Multi-Religious",
    "27" = "Anti-Atheism/Agnosticism",
    "32" = "Anti-Hispanic",
    "33" = "Anti-Other ethnicity",
    "41" = "Anti-Male Homosexual",
    "42" = "Anti-Female Homosexual",
    "43" = "Anti-Homosexual (both)",
    "44" = "Anti-Heterosexual",
    "45" = "Anti-Bisexual",
    "51" = "Anti-Physical Disability",
    "52" = "Anti-Mental Disability"
  )
  
  # Use the named vector to get the crime type
  crime_type <- crime_types[as.character(biasmo1)]
  
  # If there's no match, return NA
  if (is.null(crime_type)) {
    return(NA)
  } else {
    return(crime_type)
  }
}

# Apply this function to a dataframe with column named `state`
hate_crime_data$crime_type <- sapply(hate_crime_data$biasmo1, convert_to_crime_type)
US_hate_crime_data$crime_type <- sapply(US_hate_crime_data$biasmo1, convert_to_crime_type)

# plot graph

## hate crimes in the US

### by hate crime type
P56 = unname(createPalette(56,  c("#ff0000", "#00ff00", "#0000ff")))
p1 <- ggplot(US_hate_crime_data, aes(year, hate_crimes_per_100000)) +
      geom_point(aes(color = factor(crime_type))) +
      stat_summary(geom = "line", aes(group = crime_type, color = factor(crime_type)), fun = mean) +
      gghighlight(biasmo1 == 12 |
                  biasmo1 == 14 |
                  biasmo1 == 21 |
                  biasmo1 == 32) + # Ensure that this condition is relevant for your dataset
      labs(x = "Year", 
           y = "Hate Crimes per 100,000",
           title = "Hate Crimes per 100,000: by Hate Crime",
           color = "Crime Type") +
      theme_customs() +
      scale_color_manual(values = P56)
p1
print(p1)
ggsave(paste0(figures_wd,"/hate_crimes_byyearbyhatecrime.png"), width = 10, height = 4, units = "in")
# ggsave(paste0(thesis_plots,"/hate_crimes_byyearbyhatecrime.png"), width = 10, height = 4, units = "in")

### total hate crimes
US_hate_crime_data |> 
  group_by(year) |> 
  summarize(hate_crimes = sum(hate_crimes))
US_total_hatecrime <- US_hate_crime_data |> 
  group_by(year) |> 
  summarize(hate_crimes_per_100000 = sum(hate_crimes_per_100000))

p2 <- ggplot(US_total_hatecrime, aes(year, hate_crimes_per_100000)) +
        geom_point() +
        geom_line()+
        labs(x = "Year", 
           y = "Hate Crimes per 100,000",
           title = "Hate Crimes per 100,000 in the United States") +
        theme_customs() +
        scale_color_manual(values = P56)
p2
ggsave(paste0(figures_wd,"/hatecrimes_over_time.png"), width = 10, height = 4, units = "in")
