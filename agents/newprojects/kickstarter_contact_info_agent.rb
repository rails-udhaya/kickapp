# -*- encoding : utf-8 -*-
#~ https://www.kickstarter.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
require 'logger'
class KickstrterContactInfo
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/kickstarter_contact_info_agent_log.log", 'weekly')
        #~ $logger.level = Logger::DEBUG
        $logger.formatter = Logger::Formatter.new
    end
    
    def establish_db_connection
        # connect to the MySQL server
        get_db_connection(@options[:env])
    end
    
		def start_processing
										#~ begin
																		if $db_connection_established
																		#~ $logger.info Creator.first
																						while true do
																				@projects = Project.where(:contact_is_processed => nil,:platform_from=>"KICKSTARTER")
																						@projects.each do |project|
																								creator = project.creator
																										kickstart_project_url=project["kickstart_project_url"]
																										website_url = []
																										facebook_full_name = ""
																										facebook_url=""
																										facebook_message_url=""
																										twitter_url = []
																										@website_fetched_email = []		

																										puts bio_url = kickstart_project_url + "/creator_bio"
																										$logger.info "processing...... #{bio_url} #{project['id']}"
																												doc = Nokogiri::HTML(open("#{bio_url}"))

																										temp_1 = doc.css("div#main_content")


																										facebook_url= temp_1.css("div.facebook.py1.border-bottom.h5 a")[0]["href"] if temp_1.css("div.facebook.py1.border-bottom.h5 a")[0]
																										facebook_message_url = facebook_url.gsub("https://www.facebook.com/","https://www.facebook.com/messages/") if !facebook_url.nil?
																										facebook_full_name = temp_1.css("div.facebook.py1.border-bottom.h5 a")[0].text.gsub("'","''").strip() if temp_1.css("div.facebook.py1.border-bottom.h5 a")[0]
																												

																										temp_2 = temp_1.css("ul.links.list.h5.bold li")


																										temp_2.each do |t_2|

																										if t_2.css("a")[0]["href"].downcase.include?("twitter")
																												twitter_url.push t_2.css("a")[0]["href"]
																										end


																												if (!t_2.css("a")[0]["href"].downcase.include?("facebook") && !t_2.css("a")[0]["href"].downcase.include?("twitter") && !t_2.css("a")[0]["href"].downcase.include?("linkedin") && !t_2.css("a")[0]["href"].downcase.include?("youtube") && !t_2.css("a")[0]["href"].downcase.include?("flickr") && !t_2.css("a")[0]["href"].downcase.include?("tumblur") && !t_2.css("a")[0]["href"].downcase.include?("vimeo") && !t_2.css("a")[0]["href"].downcase.include?("pinterest") && !t_2.css("a")[0]["href"].downcase.include?("flic.kr") && !t_2.css("a")[0]["href"].downcase.include?("instagram"))
																														website_url.push t_2.css("a")[0]["href"]
																												end
																										end

																											website_url = website_url.first
																											twitter_url = twitter_url.first
																											website_url		 != ""
																												
																												
																										#~ begin
																										#~ if website_url		 != ""
																														#~ Anemone.crawl("#{website_url}", :discard_page_bodies => true, :depth_limit=>1) do |anemone|
																																#~ $logger.info "fetching emails from #{website_url}"
																																#~ puts "fetching emails from #{website_url}"
																																		#~ anemone.on_every_page do |crawled_page|
																																								#~ if !crawled_page.body.nil?
																																												#~ crawled_page.body.scan(/[\w\d]+[\w\d.-]@[\w\d.-]+\.\w{2,6}/).each do |address|
																																																														#if  @website_fetched_email.length >= 15
																																																																#error
																																																														#end
																																																																		#~ if !@website_fetched_email.include?(address)
																																																														#~ if (!address.downcase.include?(".jpeg") && !address.downcase.include?(".JPEG") && !address.include?(".jpg") && !address.downcase.include?(".JPG") && !address.downcase.include?(".png") && !address.downcase.include?(".PNG") && !address.downcase.include?(".gif") && !address.downcase.include?(".Gif") && !address.downcase.include?(".GIF") && !address.downcase.include?("._") && !address.downcase.include?(".tif") && !address.downcase.include?(".mp3"))
																																																																							#~ @website_fetched_email.push address
																																																																		#~ end
																																																																				#~ end
																																																								
																																												#~ end
																																										#~ end
																																		
																																						#~ end
																																														
																																		#~ end

																										#~ end

																										#~ rescue Exception => e
																												#~ $logger.error "Error Occured in email fetching - #{e.message}"
																												#~ $logger.error e.backtrace
																										#~ end						

																										puts website_url = website_url.gsub("'","''").strip() if website_url
																										puts twitter_url =twitter_url.gsub("'","''").strip() if twitter_url 
																										puts facebook_full_name=facebook_full_name.gsub("'","''").strip() if facebook_full_name
																										puts facebook_url=facebook_url.gsub("'","''").strip() if facebook_url
																										puts facebook_message_url=facebook_message_url.gsub("'","''").strip() if facebook_message_url
																										#~ puts 		@website_fetched_email = @website_fetched_email.join(", ")
																				begin
																								creator.update_attributes(:website_url => website_url,:twitter_url => twitter_url,:facebook_full_name => facebook_full_name,:facebook_url => facebook_url,:facebook_message_url => facebook_message_url)
																								project.update_attributes(:contact_is_processed=>true)
																						rescue Exception => e
																						project.update_attributes(:contact_is_processed=>true)
																												$logger.error "Error Occured in inserting - #{e.message}"
																												$logger.error e.backtrace
																						end
																							end	
																						end
																		end					
										#~ rescue Exception => e
														#~ $logger.error "Error Occured main - #{e.message}"
														#~ $logger.error e.backtrace
													#	sleep 300									
										#~ ensure
														#~ $logger.close
														#Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														#~ ActiveRecord::Base.clear_active_connections!
										#~ end
		end



end		

require 'rubygems'
require 'optparse'

options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: ruby newprojects_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new kickstart projects agent for building the projects' ) do |env|
    options[:env] = env
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'To get the list of available options' ) do
     opts
    exit
  end
end
optparse.parse!
		
@options = options		
require File.expand_path('../load_configurations', __FILE__)
kickstarter_contact_info_agent = KickstrterContactInfo.new(options)
kickstarter_contact_info_agent.start_processing
