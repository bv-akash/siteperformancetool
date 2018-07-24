class AddUrl

	PERFORMANCEREPORTADDR = "/home/akash/BlogVault/testjobs/files/performance_report"

	def self.queue
		:abc
	end

	def self.perform(file_loc)
		debugger
		file_location = file_loc
		File.open(file_location,'r').each_line do |line|
			line = line.strip
			url = "http://"+line
			begin
				res = HTTParty.get(url,{ timeout: 10 })
				if(res.code == 200)
					if !Blog.find_by_url(url)
						blog = Blog.create(url)
						loc = "#{PERFORMANCEREPORTADDR}/#{blog.id}"
						if !File.directory?(loc)
							Dir.mkdir(loc)
						end
						puts "Added To Database #{url}"
					else
						puts "URL Already Exists !! #{url}"
					end
				else
					puts "URL is Unreachable or Not Accesible"
				end
			rescue URI::InvalidURIError => e
				puts "Bad URL Entered #{e}"
			rescue HTTParty::UnsupportedURIScheme
				puts "This URL Scheme is Not Supported"
			rescue Net::OpenTimeout
				puts "Site is Un-Reachable. Request Time-Out"
			end
		end

		puts "Har Har Mahadev"
	end
end
