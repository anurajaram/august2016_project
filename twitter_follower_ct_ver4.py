# -*- coding: utf-8 -*-
"""
Created on Thu Jul 28 17:20:14 2016
@author: Anupama Rajaram
Description - Dashboard for Twitter Followers
"""


# load required library packages
import  tweepy, sys, locale, threading 
from time import localtime, strftime, sleep
import datetime
import csv


# compute variables for current date and time
now = datetime.datetime.now()
date_str = str(now.month) + '/' + str(now.day) + '/' + str(now.year)
time_hour = str(now.hour) + ':' + str(now.minute) + ':' + str(now.second)



# initialize token values to access twitter api.
consumer_key = "cckk"
consumer_secret = "ccss"
access_key = "aakk"
access_secret = "aasa"

# access Twitter API using OAuth function
authid = tweepy.OAuthHandler(consumer_key, consumer_secret)
authid.set_access_token(access_key, access_secret)
api = tweepy.API(authid)


# Get follower count for username = phillydotcom, phillydailynews and phillyinquirer
# open the file where twitter follower counts are stored
with open('C:/anu/python/pmn-twitter/twitter_follower_logs.csv', 'a+') as csvfile:   
    fieldnames = ['Username', 'Follower_count']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

# update count every 15 seconds - later this can be used as a cronjob
# we are simply doing this to populate the excel .csv file
    for i in range(15):
     #print(i)
     user = api.get_user("phillydotcom")
     user2 = api.get_user("phillyinquirer")
     user3 = api.get_user("phillydailynews")
     #print(user.followers_count)
              
     
     time_hour = str(now.hour) + ':' + str(now.minute) + ':' + str(now.second)    
     fieldnames = ['Date', 'Time', 'PhWeb_flct', 'PhInq_flct', 'PhNews_flct']
     writer = csv.DictWriter(csvfile, fieldnames=fieldnames)    
     writer.writerow({'Date': date_str, 'Time': time_hour, 'PhWeb_flct':user1.followers_count,
                 'PhInq_flct':user2.followers_count, 'PhNews_flct':user3.followers_count})
     #writer.writerow({'Date': date_str, 'Time': time_hour, 'Follower_count':user.followers_count})
     print(date_str, "\t", time_hour, "\t", user1.followers_count)
     sleep(15) #Sleep for 30 seconds </code>
        
     
     
     
