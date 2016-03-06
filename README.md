[![wercker status](https://app.wercker.com/status/9d6001c421c618042942e61abe9d6072/m "wercker status")](https://app.wercker.com/project/bykey/9d6001c421c618042942e61abe9d6072)

# Team7_hw3

\bold{get_lq}

Although the code was already created which only covered a 1000mile radius of stores, we had to change it to get information from all the Dennys in America. The way I did this was to choose 3 points on the map so that they covered all of the states aside from Alaska and Hawaii. The three points had zip codes of 64101, 89101 and 23218 which are Kansas City, Las Vegas and Richmond respectively. Then I choose zip codes in Alaska and Hawaii to get the last few states. This created 5 xml files in the data/dennys directory which I will use for parse_dennys.R
parse_dennys.R

I scanned through each xml file in the directory data/dennys and then compiled an array of their addresses, city, zip code, country, latitude, longitude and UID. I used rbind to make a data frame of all the 5 xml files. Because some of the Dennys are not located in the US, I just removed all values that are did not have the value US in the data frame under the country column. Then I deleted all the duplicates. In the end I found 1597 Dennys in the US. 

get_dennys

parse_lq

parse_dennys

