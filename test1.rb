require './lib/upton'

#u = Upton::Scraper.new("http://cityroom.blogs.nytimes.com/category/metropolitan-diary/", :css)
#u.scrape_to_csv("output.csv", &Upton::Utils.list("h3.entry-title", :css))

#u = Upton::Scraper.new("http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml")
#u.scrape_to_csv("output.csv", &Upton::Utils.list("item title"))


# scraper = Upton::Scraper.new("http://www.oyez.org/cases?page=97&order=field_argument_value&sort=asc", "tr.views-row-first td.views-field-title a")
scraper = Upton::Scraper.new("http://www.oyez.org/cases?page=95&order=field_argument_value&sort=asc", "table.views-table td.views-field-title a")
puts "DONE DONE DONE DONE"
# scraper.scrape_to_tsv "trying15.tsv" do |x|
scraper.scrape do |x|

	case_str = ""
	docket_str = ""
	petitioner_str = ""
	respondent_str = ""
	term_int = nil
	arg_date = nil
	dec_date = nil
	transcript_str = ""
	recusal_str = ""


	# Nokogiri::HTML(x).search("#transcript-text55274").map &:text

	case_str = (Nokogiri::HTML(x).css('head title').map &:text)[0]
	unless case_str.nil?
		case_str = case_str.strip.gsub(' | The Oyez Project at IIT Chicago-Kent College of Law', '')
	else
		case_str = ""
	end

	docket_str = (Nokogiri::HTML(x).css('div#details div.field-field-docket div.field-item').map &:text)[0]
	unless docket_str.nil?
		docket_str = docket_str.strip
	else
		docket_str = ""
	end

	petitioner_str = (Nokogiri::HTML(x).css('div#details div.field-field-petitioner div.field-item').map &:text)[0]
	unless petitioner_str.nil?
		petitioner_str = petitioner_str.strip
	else
		petitioner_str = ""
	end

	respondent_str = (Nokogiri::HTML(x).css('div#details div.field-field-respondent div.field-item').map &:text)[0]
	unless respondent_str.nil?
		respondent_str = respondent_str.strip
	else
		respondent_str = ""
	end

	term_int = (Nokogiri::HTML(x).css('div.case-term div.item-list li.first a').map &:text)[0]
	unless term_int.nil?
		term_int = term_int.strip.to_i
	else
		term_int = 0
	end

	arg_date = (Nokogiri::HTML(x).css('div#details div.field-field-argument span.date-display-single').map &:text)[0]
	unless arg_date.nil?
		arg_date = arg_date.strip
	else
		arg_date = ""
	end

	dec_date = (Nokogiri::HTML(x).css('div#details div.field-field-decision span.date-display-single').map &:text)[0]
	unless dec_date.nil?
		dec_date = dec_date.strip
	else
		dec_date = ""
	end

	transcript_str = (Nokogiri::HTML(x).css('div[id^=transcript-text]').map &:text)[0]
	unless transcript_str.nil?
		transcript_str = transcript_str.gsub(/[.\s\S]*Transcript:[\s\n\W]*/, '').strip.gsub(/\n/, "\n\n").strip
	else
		transcript_str = ""
	end

	# puts (Nokogiri::HTML(x).css('head title').map &:text)[0].strip.gsub(' | The Oyez Project at IIT Chicago-Kent College of Law', '')
	# puts (Nokogiri::HTML(x).css('div#details div.field-field-docket div.field-item').map &:text)[0].strip
	# puts (Nokogiri::HTML(x).css('div#details div.field-field-petitioner div.field-item').map &:text)[0].strip
	# puts (Nokogiri::HTML(x).css('div#details div.field-field-respondent div.field-item').map &:text)[0].strip
	# puts (Nokogiri::HTML(x).css('div.case-term div.item-list li.first a').map &:text)[0].strip
	# puts (Nokogiri::HTML(x).css('div#details div.field-field-argument span.date-display-single').map &:text)[0].strip
	# puts (Nokogiri::HTML(x).css('div#details div.field-field-decision span.date-display-single').map &:text)[0].strip
	# puts (Nokogiri::HTML(x).css('div[id^=transcript-text]').map &:text)[0].gsub(/[.\s\S]*Transcript:[\s\n\W]*/, '').strip.gsub(/\n/, "\n\n").strip

	Nokogiri::HTML(x).css('div.block div.item-list ul.case-decision li.na span.justice-icon img').map{ |x| x['title'] }.each do |y|
	
		if recusal_str == ""
			recusal_str = y
		else
			recusal_str += ", " + y
		end

	end

	puts case_str
	puts docket_str
	puts petitioner_str
	puts respondent_str
	puts term_int.to_s
	puts arg_date
	puts dec_date
	puts transcript_str
	puts recusal_str

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