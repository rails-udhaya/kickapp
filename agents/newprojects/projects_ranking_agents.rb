# -*- encoding : utf-8 -*-
#~ https://www.kickstarter.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
#~ https://www.kickstarter.com/discover/advanced?&sort=magic&format=json&page=2
require 'logger'
class ProjectRankingBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/projectsranking_agent.log", 'weekly')
        #~ $logger.level = Logger::DEBUG
        $logger.formatter = Logger::Formatter.new
    end
    
    def establish_db_connection
        # connect to the MySQL server
        get_db_connection(@options[:env])
    end
    
		def start_processing
										begin
																		if $db_connection_established

																												#~ lis=[["staff_pick_magic","https://www.kickstarter.com/discover/recommended?sort=magic&format=json&page="]]
																												
																												#~ lis=[["crafts_popular","https://www.kickstarter.com/discover/categories/crafts?sort=popularity&format=json&page="]]
lis=[["everything_popular","https://www.kickstarter.com/discover/advanced?sort=popularity&format=json&page="],
["staff_pick_popular","https://www.kickstarter.com/discover/recommended?sort=popularity&format=json&page="],
["art_popular","https://www.kickstarter.com/discover/categories/art?sort=popularity&format=json&page="],
["comics_popular","https://www.kickstarter.com/discover/categories/comics?sort=popularity&format=json&page="],
["crafts_popular","https://www.kickstarter.com/discover/categories/crafts?sort=popularity&format=json&page="],
["dance_popular","https://www.kickstarter.com/discover/categories/dance?sort=popularity&format=json&page="],
["design_popular","https://www.kickstarter.com/discover/categories/design?sort=popularity&format=json&page="],
["fashion_popular","https://www.kickstarter.com/discover/categories/fashion?sort=popularity&format=json&page="],
["filmvideo_popular","https://www.kickstarter.com/discover/categories/film & video?sort=popularity&format=json&page="],
["food_popular","https://www.kickstarter.com/discover/categories/food?sort=popularity&format=json&page="],
["games_popular","https://www.kickstarter.com/discover/categories/games?sort=popularity&format=json&page="],
["journalism_popular","https://www.kickstarter.com/discover/categories/journalism?sort=popularity&format=json&page="],
["music_popular","https://www.kickstarter.com/discover/categories/music?sort=popularity&format=json&page="],
["photography_popular","https://www.kickstarter.com/discover/categories/photography?sort=popularity&format=json&page="],
["publishing_popular","https://www.kickstarter.com/discover/categories/publishing?sort=popularity&format=json&page="],
["technology_popular","https://www.kickstarter.com/discover/categories/technology?sort=popularity&format=json&page="],
["theater_popular","https://www.kickstarter.com/discover/categories/theater?sort=popularity&format=json&page="],
["everything_magic","https://www.kickstarter.com/discover/advanced?sort=magic&format=json&page="],
["staff_pick_magic","https://www.kickstarter.com/discover/recommended?sort=magic&format=json&page="],
["art_magic","https://www.kickstarter.com/discover/categories/art?sort=magic&format=json&page="],
["comics_magic","https://www.kickstarter.com/discover/categories/comics?sort=magic&format=json&page="],
["crafts_magic","https://www.kickstarter.com/discover/categories/crafts?sort=magic&format=json&page="],
["dance_magic","https://www.kickstarter.com/discover/categories/dance?sort=magic&format=json&page="],
["design_magic","https://www.kickstarter.com/discover/categories/design?sort=magic&format=json&page="],
["fashion_magic","https://www.kickstarter.com/discover/categories/fashion?sort=magic&format=json&page="],
["filmvideo_magic","https://www.kickstarter.com/discover/categories/film & video?sort=magic&format=json&page="],
["food_magic","https://www.kickstarter.com/discover/categories/food?sort=magic&format=json&page="],
["games_magic","https://www.kickstarter.com/discover/categories/games?sort=magic&format=json&page="],
["journalism_magic","https://www.kickstarter.com/discover/categories/journalism?sort=magic&format=json&page="],
["music_magic","https://www.kickstarter.com/discover/categories/music?sort=magic&format=json&page="],
["photography_magic","https://www.kickstarter.com/discover/categories/photography?sort=magic&format=json&page="],
["publishing_magic","https://www.kickstarter.com/discover/categories/publishing?sort=magic&format=json&page="],
["technology_magic","https://www.kickstarter.com/discover/categories/technology?sort=magic&format=json&page="],
["theater_magic","https://www.kickstarter.com/discover/categories/theater?sort=magic&format=json&page="]]

																												lis.each do |l|
																														begin
																																@i= 1
																																projects_rankings = []
																																@ks_discover_query = l[0]
																																while @i <= 27
																																						puts url = l[1]+"#{@i}"
																																						ur =  URI::encode(url)
																																						uri = URI.parse(ur)
																																						http = Net::HTTP.new(uri.host, uri.port)
																																						http.use_ssl = true
																																						http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
																																						response = http.get(uri.request_uri)
																																						ou = JSON.parse(response.body) if response
																																						#~ $logger.info ou.length
																																						if ou.length > 0						
																																								ou["projects"].each do |o|
																																										if o["state"] == "live"
																																												projects_rankings << o
																																										end
																																								end				
																																						end			
																																@i=@i+1
																																end				

																																projects_rankings = projects_rankings.uniq.flatten
																																projects_rankings[0..499].each_with_index do |project_ranking,ran|
																																				reference_project_id= ""
																																				name= ""
																																				kickstart_project_url= ""
																																				puts reference_project_id = project_ranking["id"]
																																				#~ puts name =	project_ranking["name"].gsub("'","''").strip().encode("iso-8859-1").force_encoding("utf-8")
																																				puts kickstart_project_url =	project_ranking["urls"]["web"]["project"].split("?").shift
																																				puts ks_discover_query = @ks_discover_query  
																																				puts ran = ran+1
																																				begin
																																				@project_ranking		=	ProjectRanking.create(:reference_project_id => reference_project_id, :ks_discover_query=>ks_discover_query, :ranking=>ran,:kickstart_project_url=>kickstart_project_url)
																																				rescue
																																								$logger.error "mysql inserting error"
																																				end
																																		end
																																		rescue Exception => e
																																										$logger.error "Error Occured - #{e.message}"
																																										$logger.error e.backtrace
																																										sleep 10									
																																		end
																																		
																												end
#~ sleep 10
														end
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
														sleep 10									
										ensure
														$logger.close
														#~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														ActiveRecord::Base.clear_active_connections!
										end

			end																							
end		

require 'rubygems'
require 'optparse'

options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: ruby projectsranking_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the Ranking kickstart projects agent for building the projects of projects' ) do |env|
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
projectsranking_agent = ProjectRankingBuilderAgent.new(options)
puts Time.now
projectsranking_agent.start_processing
puts Time.now