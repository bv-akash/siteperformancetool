class ScreenShotHarJob

	SERVERIP = "http://192.168.1.105:8080"

def self.queue
	:abc
end

	def self.perform(link,blog_id)
		headers = {"link" => link }
		res = HTTParty.post(SERVERIP,:headers => headers)
		
		har_data = res['a']
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

		image_data = res['b']['data']
		image_data = image_data.collect do |num|
			num.to_s(16)
		end

		image_data = image_data.collect do |num|
			if num.length == 1
				"0#{num}"
			else
				num
			end
		end

		image_data = image_data.join("")
		bin_seq = [image_data.gsub(' ','')].pack('H*')
		image_file = File.open("#{loc_performance}/site_screen_shot.png",'wb')
		image_file.write(bin_seq)

		puts "Har Har Mahadev"
	end
end
