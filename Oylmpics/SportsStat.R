install.packages('tidyverse')
install.packages('dplyr')
install.packages('ggplot2')
library(tidyverse)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())
#import cleaned dataset
sum_events <- read.csv("/Users/wasin/Desktop/Olympics Project/dataset/summer_with_gdp.csv",
                       header = TRUE)

# Prepare data: count total number of participated team.
par_team <- sum_events %>% 
  count(Team)
# Change column names
colnames(par_team) <- c("Team", "athlete") 
par_team <- par_team %>%  
  arrange(desc(athlete)) 
par_team <- par_team[1:15,]

# Draw plot
ggplot(par_team, aes(reorder(Team, -athlete),athlete)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3") + 
  labs(title="Total number of participated athlete by Country", 
       subtitle="Team Vs Number of athlete",) + 
  theme(axis.text.x = element_text(angle=75, vjust=0.6))



# Prepare data: weight distribution for male medal winner.
male_weight_dis <- sum_events %>% 
  filter(Medal != "None") %>% 
  filter(Sex =="M") %>% 
  select(Weight,Medal)
#Summary of Weight
summary(male_weight_dis)

# Prepare data: weight distribution for female medal winner.
female_weight_dis <- sum_events %>% 
  filter(Medal != "None") %>% 
  filter(Sex =="F") %>% 
  select(Weight,Medal)
#Summary of Weight
summary(female_weight_dis)

ggplot(aes(x = Weight ), data = male_weight_dis) + 
  geom_histogram(aes(fill = Medal,color=Medal ), binwidth=3 , lwd=0.2) +
  scale_color_manual(values=c("black", "black", "black")) +
  scale_fill_manual(values=c("#b08d57", "#d4af37", "#aaa9ad")) +
  facet_wrap(~ Medal) +
  scale_x_continuous(breaks=seq(0,max(male_weight_dis$Weight), 10)) + 
  theme(axis.text.x = element_text(angle=0, vjust=0.6,size = 6)) +
  labs(title="Weight Distribution of Male medal winner",)

ggplot(aes(x = Weight ), data = female_weight_dis) + 
  geom_histogram(aes(fill = Medal,color=Medal ), binwidth=3 , lwd=0.2) +
  scale_color_manual(values=c("black", "black", "black")) +
  scale_fill_manual(values=c("#b08d57", "#d4af37", "#aaa9ad")) +
  facet_wrap(~ Medal) +
  scale_x_continuous(breaks=seq(0,max(female_weight_dis$Weight), 10)) + 
  theme(axis.text.x = element_text(angle=0, vjust=0.6,size = 6)) +
  labs(title="Weight Distribution of Female medal winner",)

# Prepare data: Country Wealth.
GDP <- sum_events %>% 
  select(GDP,Country.Name) %>% 
  group_by(Country.Name) %>% 
  summarize(mean = mean(GDP))  

# Change column names
colnames(GDP) <- c("Country", "GDP") 
# Sort and filter only top 10 and bottom 10
GDP_top <- GDP %>%  
  arrange(desc(GDP)) 
GDP_top <- GDP_top[1:15, ]

GDP_bot <- GDP %>%  
  arrange(GDP) 
GDP_bot <- GDP_bot[1:15, ]

#Summary of GDP
summary(GDP) 

# Prepare data: Most medal
Medal <- sum_events %>% 
  filter(Medal!="None") %>% 
  select(Country.Name) %>% 
  count( Country.Name, sort = TRUE)
colnames(Medal) <- c("Country", "Medal_count") 
Medal <- Medal[1:40, ]
  

# Draw plot: top GDP
ggplot(GDP_top, aes(reorder(Country, -GDP),GDP)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3") + 
  labs(title="Top 15 Country with Highest Avg.GDP",) + 
  theme(axis.text.x = element_text(angle=75, vjust=0.6))

# Draw plot: bottom GDP
ggplot(GDP_bot, aes(reorder(Country, GDP),GDP)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3") + 
  labs(title="Top 15 Country with Lowest Avg.GDP",) + 
  theme(axis.text.x = element_text(angle=75, vjust=0.6))


# Draw plot: Succes medal
ggplot(Medal, aes(reorder(Country, -Medal_count),Medal_count)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3") + 
  labs(title="Top 40 Countries with Highest Medalcount",) + 
  theme(axis.text.x = element_text(size=6,angle=75, vjust=0.6,face = "bold"))




# Prepare data: height distribution for male medal winner.
male_height_dis <- sum_events %>% 
  filter(Medal != "None") %>% 
  filter(Sex =="M") %>% 
  select(Height,Medal)
#Summary of Height
summary(male_height_dis)

ggplot(aes(x = Height ), data = male_height_dis) + 
  geom_histogram(aes(fill = Medal,color=Medal ), binwidth=3 , lwd=0.2) +
  scale_color_manual(values=c("black", "black", "black")) +
  scale_fill_manual(values=c("#b08d57", "#d4af37", "#aaa9ad")) +
  facet_wrap(~ Medal) +
  scale_x_continuous(breaks=seq(0,max(male_height_dis$Height), 10)) + 
  theme(axis.text.x = element_text(angle=0, vjust=0.6,size = 6)) +
  labs(title="Height Distribution of Male medal winner",)

# Prepare data: weight distribution for female medal winner.
female_height_dis <- sum_events %>% 
  filter(Medal != "None") %>% 
  filter(Sex =="F") %>% 
  select(Height,Medal)
#Summary of Height
summary(female_height_dis)

ggplot(aes(x = Height ), data = female_height_dis) + 
  geom_histogram(aes(fill = Medal,color=Medal ), binwidth=3 , lwd=0.2) +
  scale_color_manual(values=c("black", "black", "black")) +
  scale_fill_manual(values=c("#b08d57", "#d4af37", "#aaa9ad")) +
  facet_wrap(~ Medal) +
  scale_x_continuous(breaks=seq(0,max(female_height_dis$Height), 10)) + 
  theme(axis.text.x = element_text(angle=0, vjust=0.6,size = 6)) +
  labs(title="Height Distribution of female medal winner",)
