class CrawlerWorker < Worker
	def startListening
		currentJob = @redis.lpop("jobsToDo")

		if !currentJob.nil?
			jobParsed = JSON.parse currentJob
			job = Worker.new
			job.setJob(jobParsed['task'], jobParsed['url'])

			puts "#{job.task} on #{job.url}"
			saveWebPage(job.url)
			@redis.rpush('jobsDone', job.toJson)

			#self.showJobsToDo
			#self.showJobsDone
		end
	end

	def saveWebPage(url)
		webPage = Mechanize.new.get(url)
		# webPage.title
		# puts webPage.body

		# TODO
		
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