class LearnAboutDogs::Dog
	attr_accessor :name, :page_url, :blurb, :fun_fact, :description, :history, :personality, :health, :grooming, :characteristics

	@@all = []

	def initialize(name, page_url)
		@name = name
		@page_url = page_url
		@@all << self
	end

	def add_details(details) #takes hash returned from LearnAboutDogs::Scraper.scrape_profile(url) and adds breed data to the corresponding instance of dog breed
		details.each do |k,v|
			self.send("#{k}=", v)
		end
	end

	def self.all
		@@all
	end

end
