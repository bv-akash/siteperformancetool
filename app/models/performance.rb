class Performance < ApplicationRecord

	def self.create(blog_id, load_time, page_size, total_requests)
		performance = Performance.new(:blog_id => blog_id, :load_time => load_time, :page_size => page_size, :total_requests => total_requests)
		performance.save
		performance
	end
end
