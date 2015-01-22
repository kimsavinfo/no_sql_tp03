require './models/worker.rb'

urls = ["https://www.google.fr/?gws_rd=ssl", "http://ecampusbordeaux.epsi.fr/contact-info", "http://lesjoiesducode.fr/"]

jobToAdd = Worker.new
jobToAdd.setJob("GET", urls[0])
jobToAdd.saveJob()

crawlerWorker = CrawlerWorker.new
crawlerWorker.startListening

