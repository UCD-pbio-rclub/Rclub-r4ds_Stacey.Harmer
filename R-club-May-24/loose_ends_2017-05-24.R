test.data <- tibble(value=c(NA,rnorm(99,10)),
                    category=rep(LETTERS[1:5],20))
test.data

ggplot(test.data,aes(x=value)) + geom_histogram()

ggplot(test.data,aes(x=category)) + geom_bar()
summary(test.data)

# I don't see any NA cat here

length()

library(nycflights13)
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
not_cancelled %>% 
  group_by(dest,month) %>% 
  summarize(avg_delay=mean(arr_delay)) %>%
  ggplot(aes(x=month,y=dest,fill=avg_delay)) + geom_tile()


#not sure how the filtering is working:

ans.ex <- flights %>%
  group_by(month, dest) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  group_by(dest) %>%
  filter(n() == 12) %>%  # why do this? why not >= 12?
  ungroup() 

ans.ex  #1008 by 3

ans.ex.no.filter <- flights %>%
  group_by(month, dest) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  group_by(dest) %>%
  ungroup() 

# 1113 by 3 - so there were a few that didn't have at least one flight per month

my.ex <- flights %>%
  group_by(month, dest) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  group_by(dest) %>%
  filter(n() >= 12) %>%  # why do this? why not >= 12?
  ungroup() 

my.ex # also 1008 by 3

ans.ex <- ans.ex %>% 
  arrange(dest, month)

head(ans.ex, n = 28)
View(ans.ex)

df <- data.frame(abc = 1)
df
