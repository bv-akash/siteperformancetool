class YslowReq

	SERVERIP = "http://192.168.31.101:8080"
	PERFORMANCEREPORTADDR = "/home/akash/BlogVault/testjobs/files/performance_report"

def self.queue
	:abc
end

	def self.perform(performance_id,blog_id)
		loc_performance = "#{PERFORMANCEREPORTADDR}/#{blog_id}/#{performance_id}"
		performance_har_loc = "#{loc_performance}/har_file.har"

		begin
			res = RestClient.post(SERVERIP , :upload => File.new(performance_har_loc,'rb'))
		rescue EOFError => e
			puts "#{e}"
		rescue Errno::ECONNRESET => e
			puts "#{e}"
		end
		result = JSON.parse(res.body)
		yslow_score = result["score"]
		performance = Performance.find_by_id(performance_id)
		performance.update_attributes!(:yslow_score => yslow_score)
		result_file = File.new("#{loc_performance}/yslow_report.txt",'wb')
		result_file.write(res.body)
		result_file.close
		puts "#{performance_id} Har Har Mahadev"
	end
end
