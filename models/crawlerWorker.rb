require 'redis'
require 'json'
require 'mechanize'
require './models/worker.rb'
require './models/page.rb'

class CrawlerWorker < Worker

	def doJob
		self.clear
		jobToDo = @redis.lpop("jobsToDo")

		if !jobToDo.nil?
			jobParsed = JSON.parse jobToDo
			self.setJob(jobParsed['task'], jobParsed['url'])

			puts "#{self.task} on #{self.url}"
			saveWebPage(self.url)
			@redis.rpush('jobsDone', self.toJson)

			self.showJobsToDo
			self.showJobsDone
		end
	end

	def saveWebPage(url)
		webPage = Mechanize.new.get(url)
		keywords = webPage.at('meta[@name="keywords"]')
		descrition = webPage.at('meta[name="description"]')

		pageDB = Page.new
		pageDB.title = webPage.title
		pageDB.url = url
		if(!keywords.nil?)
			pageDB.keywords = keywords[:content].split(",")
		end
		if(!descrition.nil?)
			pageDB.description = descrition[:content]
		end

		if(pageDB.valid?)
			pageDB.save
		end
	end

	def showJobsToDo
		jobsToDoCount = @redis.llen 'jobsToDo'
		puts "Jobs that need to be done #{jobsToDoCount} :"
		puts @redis.lrange("jobsToDo", 0, -1)
	end

	def showJobsDone
		jobsDoneCount = @redis.llen 'jobsDone'
		puts "Done jobs #{jobsDoneCount} :"
		puts @redis.lrange("jobsDone", 0, -1)
	end
end