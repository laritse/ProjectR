#Installing required packages for cleaning and visualizations
install.packages('tidyverse')
#loading tidyverse
  library(tidyverse)
  # loading data files into R 
  activity <- read.csv("dailyActivity_merged.csv")
  calories <- read.csv("hourlyCalories_merged.csv")
  intensities <- read.csv("hourlyIntensities_merged.csv")
  sleep <- read.csv("sleepDay_merged.csv")
  weight <- read.csv("weightLogInfo_merged.csv")
  # Preview of dataframes
  head(activity)
  # Identify all the columns in the daily_activity data.
  colnames(activity)
  # Take a look at the sleep_day data.
  head(sleep)
  # Identify all the columns in the daily_activity data.
  colnames(sleep)
  head(calories)
  head(intensities)
  head(weight)
  # checking data structure 
  str(activity)
  str(sleep)
  str(calories)
  str(intensities)
  str(weight)
  #Checking for duplicate rows
  nrow(activity[duplicated(activity),])
  nrow(sleep[duplicated(sleep),])
  nrow(weight[duplicated(weight),])
  nrow(calories[duplicated(calories),])
  nrow(intensities[duplicated(intensities),])
  # removing 3 duplicate rows found in the sleep dataset
  sleep <- unique(sleep)
  nrow(sleep)
  # Checking the number of unique participants in each dataframe
  n_distinct(activity$Id)
  n_distinct(sleep$Id)
  n_distinct(calories$Id)
  n_distinct(intensities$Id)
  n_distinct(weight$Id)
  # checking the number of observations there are in each dataframe
  nrow(activity)
  nrow(sleep)
  nrow(calories)
  nrow(intensities)
  nrow(weight)
  # the following dataframes have the respective number of rows, activity - 940 rows, sleep - 410 rows, calories - 22099 rows,
  # intensities - 22099 rows, and weight - 67 rows
  # there are only 8 participants in the weight dataframe compared to the others, this number is not enough for analysis
  # standardizing date and time formats
  
  # activity
  activity$ActivityDate=as.POSIXct(activity$ActivityDate, format="%m/%d/%Y", tz=Sys.timezone())
  activity$date <- format(activity$ActivityDate, format = "%m/%d/%y")
  # sleep
  sleep$SleepDay=as.POSIXct(sleep$SleepDay, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
  sleep$date <- format(sleep$SleepDay, format = "%m/%d/%y")
  # intensities
  intensities$ActivityHour=as.POSIXct(intensities$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
  intensities$time <- format(intensities$ActivityHour, format = "%H:%M:%S")
  intensities$date <- format(intensities$ActivityHour, format = "%m/%d/%y")
  # calories
  calories$ActivityHour=as.POSIXct(calories$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
  calories$time <- format(calories$ActivityHour, format = "%H:%M:%S")
  calories$date <- format(calories$ActivityHour, format = "%m/%d/%y")
  
  # a quick statistical summary of dataframes to gain insights
  # For the activity dataframe:
  activity %>%
    select(TotalSteps,
           TotalDistance,
           VeryActiveMinutes,
           FairlyActiveMinutes,
           LightlyActiveMinutes,
           Calories,
           SedentaryMinutes) %>%
    summary()
  # For the sleep dataframe:
  sleep %>%
    select(TotalSleepRecords,
           TotalMinutesAsleep,
           TotalTimeInBed) %>%
    summary()
  # For intensities dataframe
  intensities %>%
    select(TotalIntensity,
           AverageIntensity)%>%
    summary()
  # For weight dataframe
  weight %>%
    select(WeightKg,
           WeightPounds,
           BMI)%>%
    summary()
  # this summary informs me that on avergae, participants are less active  
  # as mostly hours of inactivity were recorded compared to others. We can see that the recording of
  # lightly active minutes on average (mean) amounts to 3hrs, and sedentary minutes amount to 16hrs, this a very 
  # long period of inactivity. Investigating habits through the day will reveal why this so. 
  # For sleep summary, on average a participant slept for 7hrs once 
  
  # merging data for analysis and visualization
  activity_sleep <- merge(sleep, activity, by=c('Id', 'date'))
  head(activity_sleep)
  
  ggplot(data=sleep, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + 
    geom_point() + 
    geom_smooth(method = lm) +
    labs(title="Relationship Between Total Minutes Asleep And Total Time in Bed")
  
  intensities2 <- intensities %>%
    group_by(time) %>%
    summarise(total_int_mean = mean(TotalIntensity))
  
  # a visualization to understand participants intensity habits through the day
  ggplot(data=intensities2, aes(x=time, y=total_int_mean)) + geom_histogram(stat = "identity", fill='black') +
    theme(axis.text.x = element_text(angle = 0)) +
    labs(title="Average Total Intensity Through Hours Of The Day")
  # the above bar plot shows that the hours of 5pm to 7pm is when the most activity occurs. This may suggest that
  # earlier times of less activity may be due to working hours preventing much activity for 
  # earlier parts of the day.
  
  # relationship between sedentary minutes and calories
  ggplot(data=activity_sleep, aes(x=SedentaryMinutes, y=Calories)) + 
    geom_point() + 
    labs(title="Relationship Between Sedentary Minutes And Calories")
  
  # there appears to be no relationship between both variables as the data points have no pattern. 
  # this can be a space Bellabeat can leverage on by suggesting/introducing healthy lifestyles to users.
  # Bellabeat can leverage on this by recording long sedentary habits and encourage users to be active as inacvtivity 
  # could lead to serious health problems.
  
  # relationship between total steps and calories
  ggplot(data=activity_sleep, aes(x=TotalSteps, y=Calories)) + 
    geom_point() + 
    geom_smooth(method = lm) +
    labs(title="Relationship Between TotalSteps And Calories")
  
  #there appers to be a positive corroletion. Data points have an upward trend which confirms positive
  # relationship between Total steps and calories. This suggest that the more steps participants make, the more 
  #calories they burn. This can be used to inform users of their health achievements thereby increasing 
  # device engagement.
  
  # RECOMENDATIONS
  # ...based on the above insights to improve bellabeat app
  # 1. introduction of daily goals will encourage app engagement.
  # 2. App notifications and reminders will inform users of their health and also introduce healthy habits.
  # 3. Also, an easy app interface will lead to userfriendliness and increase customer retention.



  
^