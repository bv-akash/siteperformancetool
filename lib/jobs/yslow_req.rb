class YslowReq

	SERVERIP = "http://192.168.31.101:8080";
	PERFORMANCEREPORTADDR = "/home/akash/BlogVault/testjobs/files/performance_report"

def self.queue
	:abc
end

	def self.perform(performance_id,blog_id)
		debugger
		loc_performance = "#{PERFORMANCEREPORTADDR}/#{blog_id}/#{performance_id}"
		performance_har_loc = "#{loc_performance}/har_file.har"
		file = File.read(performance_har_loc)		
		headers = {"file" => file }
		res = HTTParty.post(SERVERIP,:headers => headers)
		result = res.body
		yslow_score = res.parsed_response["score"]
		performance = Performance.find_by_id(performance_id)
		performance.update_attributes!(:yslow_score => yslow_score)
		file = File.new("#{loc_performance}/yslow_report.txt",'wb')
		file.write(result)
		puts "Har Har Mahadev"
	end
end
