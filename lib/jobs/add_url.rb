class AddUrl

def self.queue
	:abc
end

	def self.perform(file_loc)
		file_location = file_loc
		File.open(file_location,'r').each_line do |line|
			line = line.strip
			url = "http://"+line
			if !Blog.find_by_url(url)				 
				blog = Blog.create(url)
				loc = "/home/akash/BlogVault/testjobs/files/performance_report/#{blog.id}"
				if !File.directory?(loc)
					Dir.mkdir(loc)
				end
				puts "Added To Database #{url}"
			else
				puts "URL Already Exists !! #{url}"
			end
		end
		puts "Har Har Mahadev"
	end
end
