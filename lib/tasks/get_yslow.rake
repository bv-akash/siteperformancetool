namespace :get do
	task :yslow_req => :environment do 
		performance_id = ENV['performance_id'].to_i
		performance = Performance.find_by_id(performance_id)
		Resque.enqueue(YslowReq, performance.id, performance.blog_id)
	end
end
