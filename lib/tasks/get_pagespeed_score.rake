namespace :get do
	task :pagespeed_api_req => :environment do 
		#performance_id = ENV['performance_id'].to_i
		#performance = Performance.find_by_id(performance_id)
		Performance.all.each do |performance|
			blog = Blog.find_by_id(performance.blog_id)
			Resque.enqueue(PagespeedApiReq, performance.id, performance.blog_id, blog.url)
		end
	end
end
