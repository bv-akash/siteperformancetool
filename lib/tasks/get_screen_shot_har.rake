namespace :get do
	task :screen_shot_har => :environment do 
		#blog_id = ENV['blog_id'].to_i
		#blog = Blog.find_by_id(blog_id)
		Blog.all.each do |blog|
			Resque.enqueue(ScreenShotHarJob, blog.url, blog.id)
		end
	end
end
