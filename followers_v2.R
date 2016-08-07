# author - Anupama Rajaram
# Date - August 7, 2016
# Description - Get Follower ids using Twitter API and cursor pagination

# call source file with all required packages.
source("wksp_prep.R")
library("twitteR")
library("data.table")
library(httr)
library(jsonlite)

# set variables for twitter API call authorization
consumer_key = "1DN6dH77O01AEzQtl7Hk3lrQS"
consumer_secret = "WyQJ33t8JZ0z8Q2qlnO4IDGh9TKvXHfvBsBAwZCnsLw2Ochmp5"
access_token = "3316270332-CSDn7vmTJwhz9bbsE10Jrbadylt6WJ29vVlIJ3w"
access_secret = "Ygtf6RfU1BdlG2T2HGhJtlq5KY0X3BDbAQQp4wOO8UuaB"

options(httr_oauth_cache=T) 



# sign using twitter token and token secret
myapp = oauth_app("twitter", key=consumer_key, secret=consumer_secret)
sig = sign_oauth1.0(myapp, token=access_token, token_secret=access_secret)


# initialidze dataframe to store follower ids
idlistfull <- data.frame(Follower_ids = 0)


# initialize cursor value and basic url for API calls
# we are currently getting follower ids for account = @hadleywickham
cursor = -1
api_path1 = "https://api.twitter.com/1.1/followers/ids.json?cursor="
api_path2 = "&screen_name=phillydotcom&count=5000"
iter_num = 1


# using a while loop to perform pagination when return list contains >5000 ids.
while ( cursor != 0 ) {
  # to indicate the program is working, print the iteration number & current cursor value  
  print("current iteration = " ) 
  print(iter_num)
  print("current cursor value = " ) 
  print(cursor)
  
  # create the composite url to call data from Twitter API.
  url_with_cursor = paste(api_path1, cursor, api_path2, sep = '')
  outresp = GET( url_with_cursor ,sig)
  
  # process the json received as output
  jsresp <- content(outresp)
  jsxresp <- jsonlite::fromJSON(toJSON(jsresp))
  idlist <- data.frame(jsxresp$ids)
  colnames(idlist) <- c("Follower_ids")
  
  # append the follower ids from this iteration to master follower list.
  idlistfull <- rbind(idlistfull, idlist)
  
  # update cursor to point to next cursor
  cursor = jsxresp$next_cursor
  
  # update iteration number by 1.
  iter_num = iter_num + 1
}


# write list of follower ids to csv file.
write.csv(idlistfull, file = "phdot_folr.csv", row.names = FALSE)
  
  
  