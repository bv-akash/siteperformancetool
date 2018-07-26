class ScreenShotHarJob

	SERVERIP = "http://192.168.31.101:8080"

def self.queue
	:abc
end

	def self.perform(link,blog_id)
		res = RestClient.get(SERVERIP, query = {"link" => link})
		data = JSON.parse(res.body)
		har_data = data['a']
		har_json_data = JSON.parse(har_data)
		total_requests = har_json_data['log']['entries'].count
		load_time = Time.iso8601(har_json_data['log']['entries'][total_requests-1]['startedDateTime']).to_f - Time.iso8601(har_json_data['log']['entries'][0]['startedDateTime']).to_f + har_json_data['log']['entries'][total_requests-1]['time'].to_f.round(3)/1000
		page_size = 0
		(0...total_requests).each do |index|
			size = har_json_data['log']['entries'][index]['response']['content']['size']
			compressed = har_json_data['log']['entries'][index]['response']['content']['compression'] || 0
			actual_size = size - compressed
			page_size = page_size + actual_size
		end

		new_performance = Performance.create(blog_id, load_time, page_size, total_requests)

		loc_performance = "/home/akash/BlogVault/testjobs/files/performance_report/#{blog_id}/#{new_performance.id}"
		Dir.mkdir(loc_performance)	
		
		har_file = File.open("#{loc_performance}/har_file.har",'wb')
		har_file.write(har_data)
		har_file.close

		image_data = data['b']['data']
		image_data = image_data.collect do |num|
			num.to_s(16).rjust(2, '0')
		end

		image_data = image_data.join("")
		bin_seq = [image_data.gsub(' ','')].pack('H*')
		image_file = File.open("#{loc_performance}/site_screen_shot.png",'wb')
		image_file.write(bin_seq)
		image_file.close


		full_site_screenshot_data = data['c']['data']
		full_site_screenshot_data = full_site_screenshot_data.collect do |num|
			num.to_s(16).rjust(2, '0')
		end

		full_site_screenshot_data = full_site_screenshot_data.join("")
		bin_seq = [full_site_screenshot_data.gsub(' ','')].pack('H*')
		full_site_screenshot_file = File.open("#{loc_performance}/full_site_screen_shot.png",'wb')
		full_site_screenshot_file.write(bin_seq)
		full_site_screenshot_file.close

		puts "Har Har Mahadev"
	end
end
