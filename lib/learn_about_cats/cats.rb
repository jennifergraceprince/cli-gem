class LearnAboutCats::Cat
	attr_accessor :name, :breed_url, :summary, :did_you_know, :description, :history, :personality, :grooming

	@@all = []

	def initialize(name, breed_url)
		@name = name
		@breed_url = breed_url
		@@all << self
	end

	def add_details(details) #takes hash returned from LearnAboutCats::Scraper.scrape_profile(url) and adds breed data to the corresponding instance of breed
		details.each do |k,v|
			self.send("#{k}=", v)
		end
	end

	def self.all
		@@all
	end

end
