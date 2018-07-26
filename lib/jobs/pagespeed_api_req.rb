class PagespeedApiReq 
def self.queue
	:abc
end

	def self.perform(performance_id,blog_id,blog_url)

			
		loc_performance = "/home/akash/BlogVault/testjobs/files/performance_report/#{blog_id}/#{performance_id}"
		key = 'AIzaSyAnL_4p07YTsjkM--F0N2sLEEC4l2TXVck'
		strategy = 'desktop'   #  desktop or mobile
		domain = blog_url
		url = "https://www.googleapis.com/pagespeedonline/v4/runPagespeed?url=" + \
		URI.encode(domain) + \
																"&key=#{key}&strategy=#{strategy}"

		uri = URI.parse(url)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		data = JSON.parse(response.body)
		page_speed_score = data['ruleGroups']['SPEED']['score']
		performance = Performance.find(performance_id)
		performance.update_attributes!(:page_speed_score => page_speed_score)
		file = File.new("#{loc_performance}/pagespeed_data.txt",'wb')
		file.write(response.body)
		file.close
		puts "Har Har Mahadev"
	end
end
