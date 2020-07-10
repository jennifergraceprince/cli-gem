class LearnAboutDogs::CLI

	BASE_PATH = "http://www.vetstreet.com"

	def start
		puts ""
		puts "----------------------------------------"
		puts "       Learn all about dogs!            "
		puts ""
			puts "                 __"
			puts "                /U'--,"
			puts "*_      ,--'''''   /``"
			puts " ||____,``.  )    |___"
			puts " '-----------'```-----`"
		puts "----------------------------------------"
		breeds = make_dogs
		@i = 0
		@j = 9
		list_dogs(breeds)
	end

	def make_dogs #Scrapes site index page to gather all of the breeds and breed urls
		breeds_array = LearnAboutDogs::Scraper.scrape_index(BASE_PATH + "/dogs/breeds")
		breeds_array.collect do |breed|
			LearnAboutDogs::Dog.new(breed[:name], breed[:page_url])
		end
	end

	def list_dogs(breeds) #indexes the array of dog breeds returned from make_dogs and lists each one for user to select from
		puts ""
		breeds[@i..@i+@j].each.with_index(@i + 1) {|b,i|puts "[#{i}] #{b.name}"}
		puts "[all]" if @j != 243
		puts "[less]" if @j == 243
		puts "[next]" if @i == 0 && @j == 9
		puts "[back||next]" if @i >= 10 && @i+@j <243
		puts "[back]" if @i+@j >= 243 && @j == 9
		puts ""
		puts "type [exit] at any time to close"
		puts ""
		puts "Enter the dog breed name or menu number you want to learn about:"
		input = gets.strip
		if input.to_i > 0 && input.to_i <= breeds.length
			view_breed_overview(LearnAboutDogs::Dog.all[input.to_i - 1])
		elsif LearnAboutDogs::Dog.all.detect{|breed|breed.name.downcase == input.downcase}
			view_breed_overview(LearnAboutDogs::Dog.all.detect{|breed| breed.name.downcase == input.downcase})
		elsif input.downcase == "all"
			@i = 0
			@j = 243
			list_dogs(breeds)
		elsif input.downcase == "less"
			@i = 0
			@j = 9
			list_dogs(breeds)
		elsif input.downcase == "next" && @i+@j == 243
			puts ""
			puts "That's every dog breed!"
			list_dogs(breeds)
		elsif input.downcase == "next"
			@i += 10
			list_dogs(breeds)
		elsif input.downcase == "back" && @i == 0
			puts ""
			puts "That's every dog breed!"
			list_dogs(breeds)
		elsif input.downcase == "back"
			@i -= 10
			list_dogs(breeds)
		elsif input.downcase == "exit"
			self.goodbye
		else
			puts ""
			puts "Please make a valid input."
			self.list_dogs(breeds)
		end
	end

	def view_breed_overview(breed) #upon selecting a specific dog breed, this method scrapes that breed's url page for more information
		details = LearnAboutDogs::Scraper.scrape_profile(BASE_PATH + breed.page_url)
		breed.add_details(details)
		puts ""
		puts "----------------------------------------"
		puts "Overview of the #{breed.name}"
		puts "----------------------------------------"
		puts ""
		puts "#{breed.blurb}"
		puts ""
		puts "Fun Fact!"
		puts "#{breed.fun_fact}"
		view_more_details(breed)
	end

	def view_more_details(breed) #after more info is scraped from view_breed_overview, more options are presented to learn more about breed
		puts ""
		puts "Learn more about the #{breed.name}:"
		puts "[1] Description"
		puts "[2] Characteristics"
		puts "[3] History"
		puts "[4] Personality"
		puts "[5] Grooming"
		puts "[6] Health"
		puts "[Back] to list of all dog breeds"
		input = gets.strip
		topic = nil
		info = nil
		case input.downcase
		when "1","description"
			topic = "Description"
			info = breed.description
		when "2","characteristics"
			topic = "Characteristics"
			info = Proc.new{
				i = 0
				while i < breed.characteristics.length
					puts "#{breed.characteristics[i][0]}: #{breed.characteristics[i][1]}"
					i += 1
				end
				}
		when "3","history"
			topic = "History"
			info = breed.history
		when "4","personality"
			topic = "Personality"
			info = breed.personality
		when "5","grooming"
			topic = "Grooming"
			info = breed.grooming
		when "6","health"
			topic = "Health"
			info = breed.health
		when "back"
			start
		when "exit"
			goodbye
		else
			puts ""
			puts "Please make a valid input."
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
		puts "[1] Learn more about the #{breed.name}"
		puts "[2] Learn about a different breed of dog."
		input = gets.strip
		case input.downcase
		when "1"
			view_more_details(breed)
		when "2","personality"
			start
		when "exit"
			goodbye
		else
			puts ""
			puts "Please make a valid input."
			view_topic(breed, topic, info)
		end
	end

	def goodbye #upon exiting the program, the user is presented a thank you and dog artwork
		puts ""
		puts ""
		puts "----------------------------------------"
		puts "Hope you learned something new about dogs!"
		puts "       See ya later!!            "
		puts ""
			puts "                 __"
			puts "                /U'--,"
			puts "*_      ,--'''''   /``"
			puts " ||____,``.  )    |___"
			puts " '-----------'```-----`"
		puts "----------------------------------------"
		puts "----------------------------------------"
		puts ""
		exit
	end

end
