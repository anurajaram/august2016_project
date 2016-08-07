# author - Anupama Rajaram
# Date - August 2, 2016
# Description - Twitter analysis


# call source file with all required packages.
source("wksp_prep.R")
library("twitteR")
library("data.table")
library(httr)
library(jsonlite)

# set variables for twitter API call authorization
consumer_key = "cckk"
consumer_secret = "ccss"
access_token = "a-aatt"
access_secret = "aaccsa"

options(httr_oauth_cache=T) 


# sign using token and token secret
myapp = oauth_app("twitter", key=consumer_key, secret=consumer_secret)
sig = sign_oauth1.0(myapp, token=access_token, token_secret=access_secret)

# get first 5000 followers for twitter account = "@anu_analytics"
foll_anu <- GET("https://api.twitter.com/1.1/followers/ids.json?cursor=-1&screen_name=anu_analytics&count=5000", sig)

# the list of followers is received in json format, so we process it and extract follower
# user_ids into a dataframe called "x1"
json1 = content(foll_anu)
json2 = jsonlite::fromJSON(toJSON(json1))
x1 <- data.frame(json2$ids)
colnames(x1) <- c("Follower_ids")


# create main skeleton of the url we will use for the GET call to Twitter API
api_urlp1 <- c("https://api.twitter.com/1.1/users/lookup.json?screen_name=")
api_urlp2 <- c("&user_id=")

# initialize values to create a "bare-bones" dataframe, where we will store details
# about followers - twitter_name, screen_name, location and number_of_followers
uname = "uname"
locn = "location"
uname_scr = "screen_name"
flr = 0
id = 0
df <- data.frame(id = id, name = uname, scr = uname_scr, loc = locn, ct = flr)


# use for loop to iterate through every user_id in follower list.
for( i in 1:nrow(x1))
{
  userid <- x1[i,"Follower_ids"]
  #userid = 761264099682509056
  api_url <- paste(api_urlp1,userid,api_urlp2,userid, sep = '')
  xchk <- GET(api_url,sig)
  print(userid)
  
  # process the json received if status code = 200
  if(xchk$status_code == 200)
  {
    js <- content(xchk)
    jsx <- jsonlite::fromJSON(toJSON(js))
    
    uname = jsx$name
    locn = jsx$location
    uname_scr = jsx$screen_name
    flr = jsx$followers_count
    id = jsx$id
    
    dfx <- data.frame(id = id[1], name = uname[1], scr = uname_scr[1], loc = locn[1], ct = flr[1])
    colnames(dfx) = c("id", "name", "scr", "loc", "ct")
    df <- rbind(df, dfx)
    
  }
  
  print(i)
  i = i+1
}
  
# write list of follower ids to csv file.
write.csv(df, file = "flwr_tw.csv", row.names = FALSE)