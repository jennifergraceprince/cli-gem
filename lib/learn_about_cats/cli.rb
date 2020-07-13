class LearnAboutCats::CLI

	BASE_PATH = "http://www.vetstreet.com"

	def start
		puts ""
		puts "----------------------------------------"
		puts "       Learn all about kitty cats!"
		puts "----------------------------------------"
		breeds = make_cats
		@i = 0
		@d = 9
		list_cats(breeds)
	end

	def make_cats #Scrapes /breeds to gather all of the breeds and breed urls
		breeds_array = LearnAboutCats::Scraper.scrape_index(BASE_PATH + "/cats/breeds")
		breeds_array.collect do |breed|
			LearnAboutCats::Cat.new(breed[:name], breed[:page_url])
		end
	end

	def list_cats(breeds) #indexes the array of breeds returned from make_cats and lists each one for user to select from
		puts ""
		breeds[@i..@i+@d].each.with_index(@i + 1) {|b,i|puts "#{i} - #{b.name}"}
		puts "<- all ->" if @d != 243
		puts "<- less  " if @d == 243
		puts "  next ->" if @i == 0 && @d == 9
		puts "<- previous || next ->" if @i >= 10 && @i+@d <243
		puts "<- previous  " if @i+@d >= 243 && @d == 9
		puts ""
		puts "type ALL to see the full list."
		puts "type LESS from the full list to return to the truncated list."
		puts "type NEXT to page through the list 10 at a time."
		puts "type PREVIOUS to return to the preview view."
		puts "type EXIT at any time to close the program."
		puts ""
		puts "Enter the NAME or MENU NUMBER of a breed you'd like to learn about:"
		input = gets.strip
		if input.to_i > 0 && input.to_i <= breeds.length
			view_breed_summary(LearnAboutCats::Cat.all[input.to_i - 1])
		elsif LearnAboutCats::Cat.all.detect{|breed|breed.name.downcase == input.downcase}
			view_breed_summary(LearnAboutCats::Cat.all.detect{|breed| breed.name.downcase == input.downcase})
		elsif input.downcase == "all"
			@i = 0
			@d = 243
			list_cats(breeds)
		elsif input.downcase == "less"
			@i = 0
			@d = 9
			list_cats(breeds)
		elsif input.downcase == "next" && @i+@d == 243
			puts ""
			puts "That's the whole list!"
			list_cats(breeds)
		elsif input.downcase == "next"
			@i += 10
			list_cats(breeds)
		elsif input.downcase == "previous" && @i == 0
			puts ""
			puts "That's the whole list!"
			list_cats(breeds)
		elsif input.downcase == "previous"
			@i -= 10
			list_cats(breeds)
		elsif input.downcase == "exit"
			self.goodbye
		else
			puts ""
			puts "Please make a valid input."
			self.list_cats(breeds)
		end
	end

	def view_breed_summary(breed) #when choosing a breed, this method scrapes that breed's url page for more information
		details = LearnAboutCats::Scraper.scrape_profile(BASE_PATH + breed.page_url)
		breed.add_details(details)
		puts ""
		puts "----------------------------------------"
		puts "The #{breed.name}"
		puts "                 =^o.o^="
		puts "----------------------------------------"
		puts ""
		puts "#{breed.summary}"
		puts ""
		puts "Did you know?"
		puts "#{breed.did_you_know}"
		view_more_details(breed)
	end

	def view_more_details(breed) #after more info is scraped from view_breed_summary, more options are presented to learn more about breed
		puts ""
		puts "Continue learning about the #{breed.name}:"
		puts "1 - Description"
		puts "2 - History"
		puts "3 - Personality"
		puts "4 - Grooming"
		puts "To search another breed or return to main menu, type PREVIOUS."
		input = gets.strip
		topic = nil
		info = nil
		case input.downcase
		when "1","description"
			topic = "Description"
			info = breed.description
		when "2","history"
			topic = "History"
			info = breed.history
		when "3","personality"
			topic = "Personality"
			info = breed.personality
		when "4","grooming"
			topic = "Grooming"
			info = breed.grooming
		when "previous"
			start
		when "exit"
			goodbye
		else
			puts ""
			puts "Uh oh! Not a valid input. Try a valid option."
			view_more_details(breed)
		end
		view_topic(breed, topic, info)

	end

	def view_topic(breed, topic, info) #once specific topic is selected, more information on that topic is presented to the user
		puts ""
		puts "----------------------------------------"
		puts "#{breed.name} - #{topic}"
		puts "----------------------------------------"
		puts ""
		if info.is_a?(String)
			puts "#{info}"
		else
			info.call
		end
		puts ""
		puts "1 - See details about the #{breed.name}"
		puts "2 - Return to the previous menu."
		input = gets.strip
		case input.downcase
		when "1"
			view_more_details(breed)
		when "2","history"
			start
		when "exit"
			goodbye
		else
			puts ""
			puts "Whoops! That isn't a valid input. Please try again :)"
			view_topic(breed, topic, info)
		end
	end

	def goodbye #upon exiting the program, the user is presented a thank you and cat artwork
		puts ""
		puts ""
		puts "----------------------------------------"
		puts "Hope you learned something new about cats!"
		puts "       See ya later!!            "
		puts ""
		puts "----------------------------------------"
		puts "----------------------------------------"
		puts ""
		exit
	end
end