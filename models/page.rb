require 'elasticsearch/persistence/model'

class Page
	include Elasticsearch::Persistence::Model

	attribute :title, String
	attribute :url, String
	attribute :keywords, Array
	attribute :description, String

	validates :title, presence: true
	validates :url, presence: true

	after_save { puts "Successfuly saved: #{self}" }
end