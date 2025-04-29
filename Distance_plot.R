library(ggplot2)
library(tidyr)
library(tibble)
library(dplyr)

setwd("C:/Users/zadran/Desktop/Elena_viruses/Paper_PRSSV/Distance_matrix/")

###read and subset the table to calculate the max and the min pairwise distance
distance_matrix <- read.csv("distance_matrix_PRSSV.csv", row.names = 1)
distance_matrix[distance_matrix == 0] <- NA

dist_no_out <- subset(distance_matrix, select = -c(out1,out2, Lo1,Lo2,Lo3,SW)) 
row_values <- dist_no_out[c('Lo1', 'Lo2','Lo3', 'SW'), ]


#### calcualte the 

max_value <- max(row_values, na.rm = TRUE)
min_value <- min(row_values, na.rm = TRUE)


### create a long dataset from the matrix without the outgroup and the Microtusseqeunce, delated from the column only
long_format_data_Microtus<- row_values %>%
  rownames_to_column(var = "Sample1") %>%
  pivot_longer(cols = -Sample1, names_to = "Sample2", values_to = "Distance")



long_format_data_myodes<- long_format_data_myodes[!is.na(long_format_data_myodes$Distance), ]



long_format_data <- distance_matrix %>%
  rownames_to_column(var = "Sample1") %>%
  pivot_longer(cols = -Sample1, names_to = "Sample2", values_to = "Distance")


long_format_data <- long_format_data[!is.na(long_format_data$Distance), ]




long_format_data <- long_format_data %>%
  mutate(
    Group = case_when(
      Sample1 %in% c("out1", "out2") | Sample2 %in% c("out1", "out2") ~ "Outgroup",  # Rule 1
      Sample1 %in% c("Lo1", "Lo2", "Lo3", "SW") | Sample2 %in% c("Lo1", "Lo2", "Lo3", "SW") ~ "Microtus",  # Rule 2
      TRUE ~ "Sus scrofa"  # Rule 3: Default
    )
  )



print(unique(long_format_data$Group))
length(which(long_format_data$Group=="Microtus"))
length(which(long_format_data$Group=="Outgroup"))

# If needed, clean up and fix factor levels
long_format_data$Group <- factor(long_format_data$Group, levels = c("Sus scrofa", "Microtus", "Outgroup"))

scaling_factor <- max(table(long_format_data %>% filter(Group == "Sus scrofa") %>% pull(Distance))) / max(table(long_format_data %>% filter(Group == "Microtus") %>% pull(Distance)))

calculate_mode <- function(x) {
  unique_x <- unique(x)
  unique_x[which.max(tabulate(match(x, unique_x)))]
}


dispersion_stats <- long_format_data %>%
  group_by(Group) %>%
  summarize(
    mean_distance = mean(Distance, na.rm = TRUE),
    median_distance = median(Distance, na.rm = TRUE),
    mode_distance = calculate_mode(Distance),
    sd_distance = sd(Distance, na.rm = TRUE),
    lower_1sd = mean_distance - sd_distance,
    upper_1sd = mean_distance + sd_distance,
    lower_2sd = mean_distance - 2 * sd_distance,
    upper_2sd = mean_distance + 2 * sd_distance,
    lower_3sd = mean_distance - 3 * sd_distance,
    upper_3sd = mean_distance + 3 * sd_distance,
    lower_5th_percentile = quantile(Distance, 0.05, na.rm = TRUE),
    upper_95th_percentile = quantile(Distance, 0.95, na.rm = TRUE)
  )

write.table(dispersion_stats, "dispersion_stat.csv" , sep = '')
df_filtered <- long_format_data %>% 
  filter(Group != "Outgroup")



ggplot(long_format_data %>% filter(Group %in% c("Sus scrofa", "Microtus")), aes(x = Distance, fill = Group)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density Plot of Two Groups", x = "Distance", y = "Density") +
  theme_minimal()

ggplot() +
  # First histogram for Non-Lo1 with primary y-axis
  geom_histogram(data = long_format_data %>% filter(Group == "Sus scrofa"), 
                 aes(x = Distance, y = ..count.., fill = "Sus scrofa"), 
                 binwidth = 0.005, color = "black", alpha = 0.6, position = "identity") +
  # Second histogram for Lo1 with secondary y-axis (scaled by the factor)
  geom_histogram(data = long_format_data %>% filter(Group == "Microtus"), 
                 aes(x = Distance, y = ..count.. * scaling_factor, fill = "Microtus"),  # Scale Lo1
                 binwidth = 0.005, color = "black", alpha = 0.6, position = "identity") +
  geom_histogram(data = long_format_data %>% filter(Group == "Outgroup"), 
                 aes(x = Distance, y = ..count.. * scaling_factor, fill = "Outgroup"), 
                 binwidth = 0.005, color = "black", alpha = 0.6, position = "identity") +
  scale_y_continuous(
    name = "Frequency (Sus scrofa)",
    sec.axis = sec_axis(~./scaling_factor, name = "Frequency (Microtus and Outgroup)")  # Secondary axis scaled for Microtusand Outgroup
  ) +
  scale_fill_manual(name = "P-distance groups", values = c("Sus scrofa" = "#2589BD", "Microtus" = "#F26418", "Outgroup" = "black"), breaks = c("Sus scrofa", "Microtus", "Outgroup")) +
  
  # Define colors for each group
  # Labels and theme
  labs(
    x = "Pairwise Distance",
    y = "Frequency",
    fill = "Group"
  ) +
 
  theme_light() +
  theme(legend.position = "right",
        axis.title = element_text(size = 18), 
        axis.text = element_text(size = 12),       # Increase axis text
        legend.text = element_text(size = 12),     # Increase legend text
        legend.title = element_text(size = 18) )

ggsave("p_distance.png", width=12, height=5, unit="in", dpi =600)

ggsave("p_distance.svg", width=12, height=5, unit="in", device = "svg", dpi =600)

