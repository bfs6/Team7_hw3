library(rvest)

save_dir = "data/lq"

dir.create(save_dir,recursive = TRUE, showWarnings = FALSE)

base_url = "http://www2.stat.duke.edu/~cr173/lq/www.lq.com/en/findandbook/"

page = read_html(paste0(base_url,"hotel-listings.html"))

hotel_page = page %>% 
               html_nodes("#hotelListing .col-sm-12 a") %>% 
               html_attr("href") %>%
               .[!is.na(.)]
hotel_links = paste0(base_url, hotel_page)

for(i in seq_along(hotel_page))
{
  cat("Downloading", hotel_page[i], "...\n")
  download.file(hotel_links[i], file.path(save_dir,hotel_page[i]),quiet = TRUE)
}
