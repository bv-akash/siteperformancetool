namespace :get do
	task :screen_shot_har => :environment do 
		debugger
		blog_id = ENV['blog_id'].to_i
		blog = Blog.find_by_id(blog_id)
		Resque.enqueue(ScreenShotHarJob, blog.url, blog_id)
	end
end
