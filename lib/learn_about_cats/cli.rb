class LearnAboutCats::CLI

	BASE_PATH = "http://www.vetstreet.com"

	def start
		puts ""
		puts ""
		puts ""
		puts "       Learn all about kitty cats!".bold.blue
		puts ""
		puts " _._     _,-'""`-._".red
		puts "(,-.`._,'(       |\\`-/|".red
		puts "    `-.-' \\ )-`( , o o)".red
		puts "          `-    |_``^``|_".red
		puts "                                      .... hungry kitty!"
		puts ""
		puts "                                __QQ".blink.blue
   	puts "                               (_)_\">".blink.blue
    puts "                              _)".blink.blue
		puts ""
#		puts "                =^o.o^=".blue.bold
		puts ""
		breeds = create_cats
		@i = 0
		@d = 9
		list_of_cats(breeds)
	end

	def create_cats #Scrapes /breeds to gather all of the breeds and breed urls
		breeds_array = LearnAboutCats::Scraper.scrape_index(BASE_PATH + "/cats/breeds")
		breeds_array.collect do |breed|
			LearnAboutCats::Cat.new(breed[:name], breed[:breed_url])
		end
	end

	def list_of_cats(breeds) #indexes the array of breeds returned from create_cats and lists each one for user to select from
		puts ""
		breeds[@i..@i+@d].each.with_index(@i + 1) {|b,i|puts "#{i} - #{b.name}"}
		puts ""
		puts "<- all ->".blue.bold if @d != 49
		puts "<- less  ".blue.bold if @d == 49
		puts "  next ->".green.bold if @i == 0 && @d == 9
		puts "<- previous |".yellow.bold + "| next ->".green.bold if @i >= 10 && @i+@d <49
		puts "<- previous  ".yellow.bold if @i+@d >= 49 && @d == 9
		puts ""
		puts "type ALL to see the full list.".green.bold
		puts "type LESS from the full list to return to the truncated list.".yellow.bold
		puts "type NEXT to page through the list 10 at a time.".green.bold
		puts "type PREVIOUS to return to the preview view.".yellow.bold
		puts "type EXIT at any time to close the program.".red.bold
		puts ""
		puts "                 =^o.o^=".blue.bold
		puts ""
		puts "Enter the NAME or MENU NUMBER of a breed you'd like to learn about:".bold
		input = gets.strip
		if input.to_i > 0 && input.to_i <= breeds.length
			view_breed_summary(LearnAboutCats::Cat.all[input.to_i - 1])
		elsif LearnAboutCats::Cat.all.detect{|breed|breed.name.downcase == input.downcase}
			view_breed_summary(LearnAboutCats::Cat.all.detect{|breed| breed.name.downcase == input.downcase})
		elsif input.downcase == "all"
			@i = 0
			@d = 49
			list_of_cats(breeds)
		elsif input.downcase == "less"
			@i = 0
			@d = 9
			list_of_cats(breeds)
		elsif input.downcase == "next" && @i+@d == 49
			puts ""
			puts "That's the whole list!".green.bold
			list_of_cats(breeds)
		elsif input.downcase == "next"
			@i += 10
			list_of_cats(breeds)
		elsif input.downcase == "previous" && @i == 0
			puts ""
			puts "That's the whole darn list!".green.bold
			list_of_cats(breeds)
		elsif input.downcase == "previous"
			@i -= 10
			list_of_cats(breeds)
		elsif input.downcase == "exit"
			self.goodbye
		else
			puts ""
			puts "Me-ow! That's not a valid input. Try a menu number or typing out the word you are selecting!".red.bold
			puts ""
			puts "                 =^o.o^=".red.bold
			self.list_of_cats(breeds)
		end
	end

	def view_breed_summary(breed) #when choosing a breed, this method scrapes that breed's url page for more information
		details = LearnAboutCats::Scraper.scrape_profile(BASE_PATH + breed.breed_url)
		breed.add_details(details)
		puts ""
		puts "----------------------------------------".yellow.bold
		puts "The #{breed.name} =^o.o^=".bold
		puts "----------------------------------------".yellow.bold
		puts ""
		puts ""
		puts "#{breed.summary}".blue.bold
		puts ""
		puts "Did you know?".bold
		puts ""
		puts "#{breed.did_you_know}".green.bold
		view_more_details(breed)
	end

	def view_more_details(breed) #after more info is scraped from view_breed_summary, more options are presented to learn more about breed
		puts ""
		puts "Continue learning about the #{breed.name}:".bold
		puts ""
		puts "                 =^o.o^=".bold
		puts ""
		puts "1 - Description"
		puts "2 - History"
		puts "3 - Personality"
		puts "4 - Grooming"
		puts "5 - View On Web"
		puts ""
		puts "                 =^o.o^=".bold
		puts ""
#		puts ""
#		puts "www.vetstreet.com#{breed.breed_url}".green.bold
#		puts ""
#		puts ""
		puts "To search another breed or return to the main menu, type".yellow.bold + " PREVIOUS.".bold
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
		when "5", "view on web"
			Launchy.open("http://www.vetstreet.com/" + breed.breed_url)
			puts ""
			puts "Opening the #{breed.name} detail page in your web browser.".red.bold
			view_more_details(breed)
		when "previous"
			start
		when "exit"
			goodbye
		else
			puts ""
			puts "Uh oh! Not a valid input. Try a valid option.".red.bold
			puts ""
			puts "                 =^o.o^="
			puts ""
			view_more_details(breed)
		end
		view_topic(breed, topic, info)

	end

	def view_topic(breed, topic, info) #once specific topic is selected, more information on that topic is presented to the user
		puts ""
		puts "----------------------------------------".yellow.bold
		puts "#{breed.name} - #{topic}".bold
		puts "----------------------------------------".yellow.bold
		puts ""
		if info.is_a?(String)
			puts "#{info}"
		else
			info.call
		end
		puts ""
		puts "1 - Keep learning about the #{breed.name} breed!".green.bold
		puts "2 - Go back to the previous menu.".yellow.bold
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
			puts "Whoops! That isn't a valid input. Please try again :)".red.bold
			puts ""
			view_topic(breed, topic, info)
		end
	end

	def goodbye #upon exiting the program, the user is presented a goodbye message
		puts ""
		puts ""
		puts "Thanks for coming!".bold.yellow
		puts ""
		puts " _._     _,-'""`-._".red
		puts "(,-.`._,'(       |\\`-/|".red
		puts "    `-.-' \\ )-`( , o o)".red
		puts "          `-    |_``^``|_".red
		puts "                                      .... MEOW CIAO!".green.blink
		puts ""
		puts "                                __QQ".blue
   	puts "                               (_)_\">".blue
    puts "                              _)".blue
		puts ""
		puts ""
		exit
	end
end
