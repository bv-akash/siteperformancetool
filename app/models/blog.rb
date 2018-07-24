class Blog < ApplicationRecord
	has_many :performances

	def self.create(url)
		blog = Blog.new(:url => url)
		blog.save
		blog
	end
end
