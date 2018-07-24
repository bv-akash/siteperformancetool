namespace :get do
	task :add_url_task => :environment do 
		file_loc = ENV['file_loc'].to_s
		Resque.enqueue(AddUrl, file_loc)
	end
end
