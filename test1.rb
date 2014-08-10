require './lib/upton'

require 'date'

scraper = Upton::Scraper.new("http://www.oyez.org/cases?page=139&order=field_argument_value&sort=asc", "table.views-table td.views-field-title a")

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
		arg_date = DateTime.parse(arg_date.strip).strftime('%Y-%m-%d')
	else
		arg_date = ""
	end

	dec_date = (Nokogiri::HTML(x).css('div#details div.field-field-decision span.date-display-single').map &:text)[0]
	unless dec_date.nil?
		dec_date = DateTime.parse(dec_date.strip).strftime('%Y-%m-%d')
	else
		dec_date = ""
	end

	args_array = Array.new
	(Nokogiri::HTML(x).css('div.media-player-container')).each do |z|

		z.css('div.media-player').map{|a| a['rel']}.each do |f|

			if f.include? "argument"
			correct_id = z.css('a.attachment.fancybox').map{|b| b['href']}[0]
			args_array << correct_id[1..correct_id.length]
			end

		end

	end

	transcript_count = 0
	args_array.each do |k|
		transcript_count += 1
		div_name = "div#" + k
		y = (Nokogiri::HTML(x).css(div_name).map &:text)[0]
		unless y.nil?
			y = y.gsub(/[.\s\S]*Transcript:[\s\n\W]*/, '').strip.gsub(/\n/, "\n\n").strip
		else
			y = ""
		end
		if transcript_count > 1 and y != ""
			transcript_str = transcript_str + "\n\n--\n\n" + y
		elsif transcript_count > 1 and y == ""
		else
			transcript_str = y
		end
	end





	# (Nokogiri::HTML(x).css('div[id^=transcript-text]').map &:text).each do |y|
	# 	transcript_count += 1
	# 	unless y.nil?
	# 		y = y.gsub(/[.\s\S]*Transcript:[\s\n\W]*/, '').strip.gsub(/\n/, "\n\n").strip
	# 	else
	# 		y = ""
	# 	end
	# 	if transcript_count > 1
	# 		transcript_str = transcript_str + "\n\n--\n\n" + y
	# 	else
	# 		transcript_str = y
	# 	end
	# end







	# transcript_str = (Nokogiri::HTML(x).css('div[id^=transcript-text]').map &:text)[0]
	# unless transcript_str.nil?
	# 	transcript_str = transcript_str.gsub(/[.\s\S]*Transcript:[\s\n\W]*/, '').strip.gsub(/\n/, "\n\n").strip
	# else
	# 	transcript_str = ""
	# end

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
	puts arg_date.to_s
	puts dec_date.to_s
	puts transcript_str
	puts recusal_str

end