#Install appropriate cleaning packages
install.packages("tidyverse")
install.packages("here")
install.packages("skimr")
install.packages("janitor")
install.packages("dplyr")
install.packages("lubridate")
install.packages("geodist")
install.packages("ggmap")
install.packages('ggplot2')

#Load the libraries of the installed packages
library("tidyverse")
library("here")
library("skimr")
library("janitor")
library("dplyr")
library("lubridate")
library("geodist")
library("ggmap")
library("ggplot2")
library(scales)


# Load the data
cyclistic_tripdata_2020_09 <- read_csv("data_sources/202009-divvy-tripdata.csv")
cyclistic_tripdata_2020_10 <- read_csv("data_sources/202010-divvy-tripdata.csv")
cyclistic_tripdata_2020_11 <- read_csv("data_sources/202011-divvy-tripdata.csv")
cyclistic_tripdata_2020_12 <- read_csv("data_sources/202012-divvy-tripdata.csv")
cyclistic_tripdata_2021_01 <- read_csv("data_sources/202101-divvy-tripdata.csv")
cyclistic_tripdata_2021_02 <- read_csv("data_sources/202102-divvy-tripdata.csv")
cyclistic_tripdata_2021_03 <- read_csv("data_sources/202103-divvy-tripdata.csv")
cyclistic_tripdata_2021_04 <- read_csv("data_sources/202104-divvy-tripdata.csv")
cyclistic_tripdata_2021_05 <- read_csv("data_sources/202105-divvy-tripdata.csv")
cyclistic_tripdata_2021_06 <- read_csv("data_sources/202106-divvy-tripdata.csv")
cyclistic_tripdata_2021_07 <- read_csv("data_sources/202107-divvy-tripdata.csv")
cyclistic_tripdata_2021_08 <- read_csv("data_sources/202108-divvy-tripdata.csv")

# combine data
bike_rides <- rbind(
  cyclistic_tripdata_2020_09, cyclistic_tripdata_2020_10,
  cyclistic_tripdata_2020_11, cyclistic_tripdata_2020_12, cyclistic_tripdata_2021_01,
  cyclistic_tripdata_2021_02, cyclistic_tripdata_2021_03, cyclistic_tripdata_2021_04,
  cyclistic_tripdata_2021_05, cyclistic_tripdata_2021_06, cyclistic_tripdata_2021_07,
  cyclistic_tripdata_2021_08
)

# check data
bike_rides %>% 
  skim_without_charts()



#Cleaning data


bike_rides <- bike_rides %>%
  clean_names() %>% 
  remove_empty(which = c("rows","cols")) %>% 
  distinct() %>% 
  rename(rider_type = member_casual) %>% 
  rename(bike_type = rideable_type) %>% 
  mutate(ride_length = difftime(ended_at,started_at), #, units = "secs"
         day_of_week = weekdays(started_at)
         ) 

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
bike_rides$ride_length <- as.numeric(as.character(bike_rides$ride_length))
is.numeric(bike_rides$ride_length)

#Separate started_at column into start_date and start_time
bike_rides <- bike_rides %>% 
  separate(started_at, into = c('start_date','start_time'), sep = ' ') %>%
  separate(ended_at, into = c('end_date','end_time'), sep = ' ')

#convert chr to date
bike_rides$start_date<- ymd(bike_rides$start_date)
bike_rides$end_date<- ymd(bike_rides$end_date)

#Convert chr to period
bike_rides$start_time <- hms(bike_rides$start_time)
bike_rides$end_time <- hms(bike_rides$end_time)

#Get hour from period
bike_rides$start_hour <- hour(bike_rides$start_time)

#Get day, month and year of the rides
bike_rides<-bike_rides %>% 
  mutate(
    day = day(start_date),
    month = month(start_date),
    year = year(start_date)
  )


#Make a minutes column for ride length
bike_rides$ride_length_m <- minute(seconds_to_period(bike_rides$ride_length))
bike_rides$month_abb <- month.abb[bike_rides$month]

#remove rows with negative ride_length
bike_rides<-bike_rides %>% 
  filter(ride_length_m > 0)

#drop_na values, ensure uniqueness, remove redundant variables
#rename a variable, add a new variable, filter for only poisitive values
bike_rides<- bike_rides %>% 
  mutate(ride_distance = geodist_vec(start_lng,
                              start_lat,
                              end_lng,
                              end_lat,
                              paired = TRUE,
                              sequential = TRUE, 
                              measure = "cheap"),
  ride_dist_mile = ride_distance/1609
  ) %>% 
  filter(ride_dist_mile > 0) %>% 
  select(-ride_distance)

#ADD season to data frame
bike_rides<-bike_rides %>% 
  mutate(
    season = ifelse(
      month %in% 9:11, "Fall",
      ifelse(month %in% 1:2, "Winter",
             ifelse(month %in% 12, "Winter",
                    ifelse(month %in% 3:5, "Spring",
                           "Summer")
             )
      )
         )
    )

##################################
#ANALYSIS
##################################

mean(bike_rides$ride_length_m) #straight average (total ride length / rides)
median(bike_rides$ride_length_m) #midpoint number in the ascending array of ride lengths
max(bike_rides$ride_length_m) #longest ride
min(bike_rides$ride_length_m) #shortest ride

mean(bike_rides$ride_dist_mile) #straight average (total ride length / rides)
median(bike_rides$ride_dist_mile) #midpoint number in the ascending array of ride lengths
max(bike_rides$ride_dist_mile) #longest ride
min(bike_rides$ride_dist_mile) #shortest ride

#compare members to casual riders
aggregate(bike_rides$ride_length_m ~ bike_rides$rider_type, FUN = mean)
aggregate(bike_rides$ride_length_m ~ bike_rides$rider_type, FUN = median)
aggregate(bike_rides$ride_length_m ~ bike_rides$rider_type, FUN = max)
aggregate(bike_rides$ride_length_m ~ bike_rides$rider_type, FUN = min)

aggregate(bike_rides$ride_dist_mile ~ bike_rides$rider_type, FUN = mean)
aggregate(bike_rides$ride_dist_mile ~ bike_rides$rider_type, FUN = median)
aggregate(bike_rides$ride_dist_mile ~ bike_rides$rider_type, FUN = max)
aggregate(bike_rides$ride_dist_mile ~ bike_rides$rider_type, FUN = min)

# ORDER THE DAYS OF THE WEEK.
bike_rides$day_of_week <- ordered(bike_rides$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

#ORDER MONTHS
bike_rides$month_abb <- ordered(bike_rides$month_abb, levels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

# Order seasons
bike_rides$season <- ordered(bike_rides$season, levels=c("Spring", "Summer", "Fall", "Winter"))

bike_rides %>% 
  group_by(rider_type) %>% 
  summarise(number_rides = n(), average_ride_length = mean(ride_length_m),average_ride_distance = mean(ride_dist_mile)) %>% 
  arrange(desc(number_rides))

#Count the number of rides by weekday and by member
bike_rides %>% 
  group_by(rider_type, day_of_week) %>% 
  summarise(number_rides = n(), average_ride_length = mean(ride_length_m), average_ride_distance = mean(ride_dist_mile)) %>% 
  arrange(rider_type)

#Count the number of rides and average ride length at every start hour
bike_rides %>% 
  group_by(start_hour) %>% 
  summarise(number_rides = n(), average_ride_length = mean(ride_length_m), average_ride_distance = mean(ride_dist_mile)) %>% 
  arrange(desc(number_rides))

bike_rides %>% 
  group_by(rider_type,season) %>% 
  summarise(number_rides = n(), average_ride_length = mean(ride_length_m),average_ride_distance = mean(ride_dist_mile)) %>% 
  arrange(desc(number_rides))




###############################
#VISUALIZATION
###############################


mindate <- min(bike_rides$start_date)
maxdate <- max(bike_rides$start_date)


###################
#Number of Rides
###################


# Rider Type by Bike Type
bike_rides %>% 
  group_by(bike_type,rider_type) %>% 
  summarise(number_of_rides = n()) %>% 
  ggplot(mapping = aes(x = bike_type, y = number_of_rides, fill = rider_type))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(title="Number of Rides for Users by Bike Type",
       subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
       x = "Bike Type",
       y = "Number of Rides")

#total number of rides by day of month
bike_rides %>%
  filter(rider_type %in% c('casual','member')) %>%
  count(rider_type, day) %>%
  ggplot(aes(x=day,y=n,color=rider_type,group=rider_type)) + 
  geom_point() + 
  geom_line(linetype='dotted')+
  scale_y_continuous(labels = comma)+
  labs(title="Number of Rides for Users by Day of Month", 
       subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
       x = "Day of Month", 
       y = "Number of Rides")

#total number of rides by season
bike_rides %>%
  filter(rider_type %in% c('casual','member')) %>%
  count(rider_type, season) %>%
  ggplot(aes(x=season,y=n,fill=rider_type,group=rider_type)) + 
  geom_col(position = "dodge") + 
  scale_y_continuous(labels = comma)+
  labs(title="Number of Rides for Users by Season", 
       subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
       x = "Season", 
       y = "Number of Rides")


# Rider Type by Time of Day
bike_rides %>%
  filter(rider_type %in% c('casual','member')) %>%
  count(rider_type, start_hour) %>%
  ggplot(aes(x=start_hour,y=n,color=rider_type,group=rider_type)) + 
  geom_point() + 
  geom_line(linetype='dotted')+
  scale_y_continuous(labels = comma)+
  theme(axis.text.x  = element_text(size=8,angle=90)) + 
  labs(title="Number of Rides for Users by Time of Day", 
       subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
       x = "Time of Day", 
       y = "Number of Rides")

#Rider Type by Weekday
bike_rides %>%
  group_by(day, rider_type) %>%
  summarize(number_of_rides = n(),
            wday = day_of_week[1]) %>%
  group_by(wday, rider_type) %>%
  summarize(average_num_rides=mean(number_of_rides)) %>%
  ggplot(aes(x=wday,y=average_num_rides, fill = rider_type)) + 
  geom_bar(stat='identity', position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(title=" Average Number of Rides for Users by Weekday", 
       subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
       x = "Day of Week", 
       y = "Average Number of Rides")


#Rider Type by month
bike_rides %>% 
  group_by(month_abb, rider_type) %>%
  summarize(number_of_rides = n(),
            month = month_abb[1]) %>%
  group_by(month, rider_type) %>%
  ggplot(mapping = aes(x = month, y = number_of_rides, fill = rider_type))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(title="Number of Rides for Users by Month", 
       subtitle=paste0("Data from: ", mindate, " to ", maxdate),
       x = "Month ", 
       y = "Number of Rides")

#number of rides for users by time of day for each day of week
bike_rides %>%
  filter(rider_type %in% c('casual','member')) %>%
  group_by(day_of_week, rider_type, start_hour) %>%
  summarize(number_of_rides = n(),
            wday = day_of_week[1]) %>%
  group_by(wday, rider_type, start_hour) %>%
  summarize(average_num_rides=mean(number_of_rides)) %>%
  ggplot(aes(x=start_hour,y=average_num_rides, group = rider_type,
             color = rider_type, linetype = rider_type, shape = rider_type)) + 
  geom_point(size=2) + 
  geom_line(size=0.5) + 
  facet_wrap(~wday,nrow=1)+
  scale_y_continuous(labels = comma)+
  labs(title=" Average Number of Rides for Users by Time of Day and Weekday", 
       subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
       x = "Time of Day", 
       y = "Average Number of Rides")+
  theme(axis.text.x  = element_text(size=8,angle=90),
        legend.position="none")

#######################
#RIDE DURATION
#######################

#Histogram to see distribution of ride length
bike_rides %>%
  ggplot(aes(x=ride_length_m))+ 
  geom_histogram()+
  scale_y_continuous(labels = comma)+
  labs(
    title="Distribution of Ride Duration", 
    subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
    x = "Ride Duration (Mins.)", 
    y = "Number of Rides")

#Histogram to see distribution of ride length for each user
bike_rides %>%
  ggplot(aes(x=ride_length_m))+ 
  geom_histogram()+
  scale_y_continuous(labels = comma)+
  facet_wrap(~rider_type)+
  labs(
    title="Distribution of Ride Duration for Users", 
    subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
    x = "Ride Duration (Mins.)", 
    y = "Number of Rides")

#Density plot
bike_rides %>%
  ggplot(aes(x=ride_length_m, fill = rider_type))+ 
  geom_density(alpha = 0.5)+
  scale_y_continuous(labels = comma)+
  labs(
    title="Distribution of Ride Duration for Users", 
    subtitle=paste0("Data from: ", mindate, " to ", maxdate), 
    x = "Ride Duration (Mins.)", 
    y = "Number of Rides")

#Median Trip duration by day of month
bike_rides %>%
  group_by(day) %>%
  summarize(med.duration=median(ride_length_m),
            weekday=day_of_week[1]) %>%
  ggplot(aes(x=day,y=med.duration,group=1)) + 
  geom_point(aes(color=weekday),size=5) + 
  geom_line(linetype='dotted')+
  labs(x='Day of Month',
       y='Median Ride Duration (Mins.)',
       title='Median Ride Duration by Day of Month',
       subtitle=paste0("Data from: ", mindate, " to ", maxdate)
       )

#Median ride duration by time of day
bike_rides %>%
  group_by(start_hour) %>%
  summarize(med.duration=median(ride_length_m)) %>%
  ggplot(aes(x=start_hour,y=med.duration)) + 
  geom_point() + 
  geom_line(aes(group=1),linetype='dotted')+
  labs(x='Time of Day',
       y='Median Ride Duration (Mins.)',
       title='Ride Duration by Time of Day',
       subtitle=paste0("Data from: ", mindate, " to ", maxdate)
  )


#Median ride duration by time of day for each week day
bike_rides %>%
  group_by(day_of_week,start_hour) %>%
  summarize(med.duration=median(ride_length_m)) %>%
  ggplot(aes(x=start_hour,y=med.duration,group=day_of_week,color=day_of_week))+ 
  geom_point(size=3) + 
  geom_line(size=0.5) + 
  facet_wrap(~day_of_week,nrow=1) + 
  theme(legend.position="none", 
        axis.text.x  = element_text(size=8,angle=90) )+
  scale_x_discrete(breaks=c(0,3,6,9,12,15,18,21))+
  labs(x='Time of Day',
       y='Median Ride Duration (Mins.)',
       title='Ride Duration by Time of Day and Weekday',
       subtitle=paste0("Data from: ", mindate, " to ", maxdate)
  )


#Median ride duration by time of day for each week day PER USER
bike_rides %>%
  filter(rider_type %in% c('casual','member')) %>%
  group_by(day_of_week,start_hour,rider_type) %>%
  summarize(med.duration=median(ride_length_m)) %>%
  ggplot(aes(x=start_hour,y=med.duration,group=rider_type,
             color=rider_type,linetype=rider_type,shape=rider_type)) + 
  geom_point(size=2) + 
  geom_line(size=0.5) + 
  facet_wrap(~day_of_week,nrow=1) + 
  labs(x='Time of Day',
       y='Median Ride Duration (Mins.)',
       title='Ride Duration for Users by Time of Day and Weekday',
       subtitle=paste0("Data from: ", mindate, " to ", maxdate)
  )+
  scale_x_discrete(breaks=c(0,6,12,18))



#Not Sure If This is Necessary Yet.
# Rider Type by Bike Type 
bike_rides %>% 
  group_by(bike_type,rider_type) %>% 
  filter(ride_length_m > 0) %>% 
  summarise(med.duration=median(ride_length_m)) %>% 
  ggplot(mapping = aes(x = bike_type, y = med.duration, fill = rider_type))+
  geom_col(position = "dodge")+
  scale_y_continuous(labels = comma)+
  labs(title="Ride Duration for Users by Bike Type",
       subtitle=paste0("Data from: ", mindate, " to ", maxdate),
       x = "Bike Type", 
       y = "Average Ride Duration (Mins.)")



############################
#RIDE LOCATION
###########################

#Get API key
api<- "AIzaSyARZ-9xlZw7BCgLNOFdOgv_t4tPpMNqz6M"
#Register API with google
register_google(key = api)
## get station info
station.info <- bike_rides %>%
  drop_na() %>% 
  distinct() %>% 
  group_by(start_station_id) %>%
  summarise(lat=as.numeric(start_lat[1]),
            long=as.numeric(start_lng[1]),
            name=start_station_name[1],
            n.trips=n())


## get map and plot station locations 
chicago.map <- get_map(location= 'Chicago', 
                       maptype='roadmap', color='bw',source='google',zoom=13)

#Mapping station activity
ggmap(chicago.map) + 
  geom_point(data=station.info,aes(x=long,y=lat,color=n.trips),size=3,alpha=0.75)+
  scale_colour_gradient(high="blue",low='yellow')+ 
  theme(axis.ticks = element_blank(),axis.text = element_blank())+
  xlab('')+ylab('')


#Mapping Rider location
rider.location<- bike_rides %>%
  drop_na() %>% 
  distinct() %>% 
  filter(ride_dist_mile>0 & ride_length_m > 0) %>% 
  select(start_station_id,start_station_name, start_lat, start_lng,rider_type)


ggmap(chicago.map) + 
  geom_point(data = rider.location,
             aes(x=start_lng,y=start_lat,color=rider_type),size=.10,alpha=0.5) + 
  # facet_wrap(~rider_type)+
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position="none")


#Mapping busiest station

#to find busiest station
top.station <- bike_rides %>%
  drop_na() %>% 
  group_by(start_station_id) %>%
  summarise(n.trips=n(),
            name=start_station_name[1],
            lat=start_lat[1],
            lon=start_lng[1]) %>%            
  arrange(desc(n.trips)) %>%
  slice(1)


#to find top 20 trip from busiest station
busy.station.out <- bike_rides %>%
  drop_na() %>% 
  filter(start_station_id== as.numeric(top.station$start_station_id)) %>%
  group_by(end_station_id) %>%
  summarise(n.trips=n(),
            name=end_station_name[1],
            start.lat = as.numeric(start_lat[1]),
            start.lon = as.numeric(start_lng[1]),
            end.lat = as.numeric(end_lat[1]),
            end.lon = as.numeric(end_lng[1])) %>%
  arrange(desc(n.trips)) %>% 
  slice(1:20)

#plot results

map_busiest <- get_map(location = c(lon = top.station$lon, 
                               lat = top.station$lat), color='bw',source='google',zoom=14)


ggmap(map_busiest) + 
  geom_segment(data=busy.station.out,aes(x=start.lon,y=start.lat,
                                         xend=end.lon,yend=end.lat,
                                         color=n.trips),size=1,alpha=0.75) +
  geom_point(data=busy.station.out,aes(x=end.lon,y=end.lat,color=n.trips), size=3,alpha=0.75) + 
  geom_point(data=top.station, aes(x=lon,y=lat), size=4, alpha=0.5) +
  scale_colour_gradient(high="red",low='green') + 
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  xlab('')+ylab('') +
  ggtitle(paste0('Top 20 Trips starting at ', top.station$name))

