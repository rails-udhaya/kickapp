#~ 10832
# -*- encoding : utf-8 -*-
#~ https://www.kickstarter.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
require 'logger'
class FullProjectBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/fullprojects_agent.log", 'weekly')
        #~ $logger.level = Logger::DEBUG
        $logger.formatter = Logger::Formatter.new
    end
    
    def establish_db_connection
        # connect to the MySQL server
        get_db_connection(@options[:env])
    end
    
		def start_processing(proj)
										begin
																		if $db_connection_established
																		#~ $logger.info Creator.first
																						#~ while true do
																						#~ lis = KickstarterCategory.where(:is_processed => false)
																						lis = proj
																						lis.each do |l|

																										@i = 1
																										@num = 200
																										while @i < @num  do	
																														url = "#{l["category_url"]}&page=#{@i}"
																														puts  url
																														$logger.info  url
																														doc = Nokogiri::HTML(open("#{url}"))
																														temp_1 = doc.css("ul#projects_list li.project.col.col-3.mb4")
																														if temp_1.length > 0
																																temp_1.each do |t_1|
																																		by_line = t_1.css("p.project-byline").text
																																		ur =  URI::encode("https://www.kickstarter.com/projects/search.json?term="+t_1.css("h6.project-title").text)
																																		uri = URI.parse(ur)
																																		http = Net::HTTP.new(uri.host, uri.port)
																																		http.use_ssl = true
																																		http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
																																		response = http.get(uri.request_uri)
																																		ou = JSON.parse(response.body) if response
																												
																																		if ou.length > 0						
																																						ou["projects"].each do |o|
																																								begin
																																								
																																														reference_creator_id= "" 
																																														creator_name= "" 

																																														#~ projects variables
																																														reference_project_id="" 
																																														project_name="" 
																																														state=""
																																														currency="" 
																																														currency_symbol="" 
																																														photo="" 
																																														project_location=""
																																														creator_id="" 
																																														backers_count="" 
																																														goal="" 
																																														pledged="" 
																																														project_urls="" 
																																														launched_at="" 
																																														deadline="" 
																																														state_changed_at=""
																																														kickstart_project_url = ""
																																														category = ""
																																														sub_category = ""
																																														slug = ""

																																										creator_name = o["creator"]["name"].gsub("'","''").strip()
																																										reference_creator_id = o["creator"]["id"]
																																										reference_project_id = o["id"]
																																										project_name = o["name"].gsub("'","''").strip()
																																										state = o["state"]
																																										currency = o["currency"]
																																										currency_symbol = o["currency_symbol"]
																																										photo = o["photo"]
																																										project_location = o["location"]
																																										backers_count = o["backers_count"]
																																										goal = o["goal"]
																																										pledged = o["pledged"]
																																										project_urls = o["urls"]
																																										launched_at = o["launched_at"]
																																										deadline = o["deadline"]
																																										state_changed_at = o["state_changed_at"]
																																										kickstart_project_url = o["urls"]["web"]["project"].split("?").shift
																																										slug = o["category"]["slug"].split("/")
																																										
																																										#~ For category
																																										if slug.length == 2
																																												category = slug.first.split.map(&:capitalize).join(' ').gsub("'","''").strip()
																																												sub_category = slug.last.split.map(&:capitalize).join(' ').gsub("'","''").strip()
																																										elsif slug.length == 1
																																												category = slug.first.split.map(&:capitalize).join(' ').gsub("'","''").strip()
																																										end
																												
																																										
																																										
																																										
																																										if (by_line.downcase == creator_name.downcase)
																																												 @pro = Project.where(:reference_project_id=>reference_project_id,:platform_from=>"KICKSTARTER")
																																														if @pro.count <= 0
																																																#~ puts creator_name.downcase
																																																#~ puts DateTime.strptime("#{o['created_at']}",'%s')
																																																if (o['created_at'] < Date.new(2015,05,31).to_time.to_i)

																																																				@creator= Creator.where(:reference_creator_id => reference_creator_id).first
																																																						if !@creator
																																																								@creator = Creator.create(:reference_creator_id =>reference_creator_id, :name => creator_name)
																																																								puts "Creating new creator"
																																																								$logger.info "Creating new creator"
																																																						else
																																																								puts "Using already existing creator"
																																																								$logger.info "Using already existing creator"
																																																						end

																																																				@project		=	@creator.projects.create(:reference_project_id => reference_project_id, :name => project_name,:state => state, :currency => currency, :currency_symbol => currency_symbol,:photo => photo,:location => project_location,:goal => goal,:urls => project_urls, :launched_at => launched_at, :deadline => deadline, :state_changed_at => state_changed_at,:kickstart_project_url=>kickstart_project_url,:category => category, :sub_category => sub_category,:platform_from=>"KICKSTARTER",:partial_data=>true)
																																																				@project.pledged_backers.create(:pledged=>pledged, :backers_count=>backers_count,:pledges_created_at=>Time.now.in_time_zone("Pacific Time (US & Canada)"))
																																																				puts "Assigned project to creator"
																																																				$logger.info "Assigned project to creator"
																																																
																																																end
																																														end

																																										end
																																								rescue Exception => e
																																												$logger.error "Error Occured - #{e.message}"
																																								end
																																						end
																																						
																																end
																																end
																														end
																										@i=@i+1
																								end
																									 KickstarterCategory.where(:category_url =>l["category_url"]).update_all(:is_processed => true)
																						end

													

																		end
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
														#~ sleep 300									
										ensure
														$logger.close
														#~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														ActiveRecord::Base.clear_active_connections!
										end
								end
								
								
								
								
								
								
								
								def multy_process
             $logger.info Time.now
              begin
            if $db_connection_established
              
                                #~ cnt = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").count / 5
                                #~ s_project_1 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").limit(cnt)
                                #~ s_project_2 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt).limit(cnt)
																																
                                s_project_1 = KickstarterCategory.where(:is_processed => false)
                                s_project_2 = KickstarterCategory.where("id > 200 and is_processed = false")
                                #~ s_project_3 = KickstarterCategory.where("id > 300 and is_processed = false")
                                #~ s_project_4 = KickstarterCategory.where("id > 400 and is_processed = false")
                                #~ s_project_5 = KickstarterCategory.where("id > 500 and is_processed = false")


														
                
                   t_1 =  Thread.new{
                   $logger.info "thread 1"
                    start_processing(s_project_1)
                    }
              
              sleep 5
                   t_2 =  Thread.new{
                   $logger.info "thread 2"
                    start_processing(s_project_2)
                    }
              sleep 5
                   #~ t_3 =  Thread.new{
                   #~ $logger.info "thread 3"
                    #~ start_processing(s_project_3)
                    #~ }
              #~ sleep 5
                   #~ t_4 =  Thread.new{
                   #~ $logger.info "thread 4"
                    #~ start_processing(s_project_4)
                    #~ }
              #~ sleep 5
                   #~ t_5 =  Thread.new{
                   #~ $logger.info "thread 5"
                    #~ start_processing(s_project_5)
                    #~ }
              
														
                t_1.join
                t_2.join
                #~ t_3.join
                #~ t_4.join
                #~ t_5.join


            end    
              rescue Exception => e
              puts "Error Occured-thread - #{e.message}"
                          $logger.error "Error Occured - #{e.message}"
                          $logger.error e.backtrace
                          #~ sleep 2									
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
  opts.banner = "Usage: ruby newprojects_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new kickstart full projects agent for building the projects' ) do |env|
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
fullprojects_agent = FullProjectBuilderAgent.new(options)
fullprojects_agent.multy_process
