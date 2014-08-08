require './lib/upton'

#u = Upton::Scraper.new("http://cityroom.blogs.nytimes.com/category/metropolitan-diary/", :css)
#u.scrape_to_csv("output.csv", &Upton::Utils.list("h3.entry-title", :css))

#u = Upton::Scraper.new("http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml")
#u.scrape_to_csv("output.csv", &Upton::Utils.list("item title"))


scraper = Upton::Scraper.new("http://www.oyez.org/cases?page=77&order=field_argument_value&sort=asc", "tr.views-row-first td.views-field-title a")
puts "DONE DONE DONE DONE"
scraper.scrape_to_tsv "trying.tsv" do |x|
	Nokogiri::HTML(x).search("#transcript-text55274").map &:text
end

  # puts &Upton::Utils.list("div#transcript-text83210")






# scraper = Upton::Scraper.new("http://www.oyez.org/cases?order=field_argument_value&sort=asc", ".compact-list a.title-link")
# scraper.paginated = true
# scraper.pagination_param = 'page'
# scraper.pagination_max_pages = 1
# scraper.scrape_to_csv("cases.csv", &Upton::Utils.list("h2"))
# end






# scraper = Upton::Scraper.new("http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml", "item link")
# scraper.scrape do |article_html_string|
#   scraper.scrape_to_csv("output.csv", &Upton::Utils.list("article.story"))
#   #or, do other stuff here.
# end


# scraper = Upton::Scraper.new("http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml", "item link")
# scraper.scrape do |article_html_string|
#   puts "here is the full html content of the ProPublica article listed on the homepage: "
#   puts "#{article_html_string}"
#   #or, do other stuff here.
# end