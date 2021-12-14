stats <- read_csv('hitting.csv')

stats <- stats %>%
  separate(Date, c('date_new', 'game_num'), sep = ' ') %>%
  mutate(game_num = replace_na(game_num, 1))

stats$game_num <- gsub('[()]', '', stats$game_num)

write_csv(stats, 'hitting_cleaned.csv', na = '')