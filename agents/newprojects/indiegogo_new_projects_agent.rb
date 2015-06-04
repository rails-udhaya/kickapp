# -*- encoding : utf-8 -*-
#~ https://www.indiegogoer.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
require 'logger'
class IndiegogoNewProjectBuilderAgent
		
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
								@indiego_api_config = "e88bd0a00305bfdfb18003a75665643b"
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/indiegogo_new_projects_agent.log", 'weekly')
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
																										@indiegogo_new_project_url = "https://api.indiegogo.com/1.1/search/campaigns.json?api_token=#{@indiego_api_config}&sort=new&per_page=200"
																										puts @indiegogo_new_project_url
																										uri = URI.parse(@indiegogo_new_project_url)
																										http = Net::HTTP.new(uri.host, uri.port)
																										http.use_ssl = true
																										http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
																										response = http.get(uri.request_uri)
																										a = JSON.parse(response.body)
																										projects = a["response"]

																										projects.each do |project|
																												begin
																												$logger.info "Processing next project #{project.id}"
																														reference_creator_id= "" 
																																		creator_name= "" 
																																		
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

																																

																												team_members = project["team_members"]
																												team_members.each do |team_member|
																																
																												if (team_member["user_type"] == "RLTN_OWNR")
																															reference_creator_id =team_member["account_id"]
																																creator_name  = team_member["name"]
																														end
																												end		
																																reference_project_id = project["id"]
																																project_name = project["title"]
																																currency = project["currency"]["iso_code"] if project["currency"]
																																currency_symbol = project["currency"]["symbol"] if project["currency"]
																																photo = project["image_types"]
																																goal = project["goal"]
																																kickstart_project_url = "https://www.indiegogo.com/projects/"+project["slug"]
																																backers_count = project["contributions_count"]
																																pledged = project["collected_funds"]
																																category = project["category"]["name"] if project["category"] 
																																project_location = {"region_code" => project["region_code"],"region" => project["region"],"country_code_alpha_2" => project["country_code_alpha_2"],"country" => project["country"],"city" => project["city"]}
																																#~ project["funding_started_at"]
																																#~ project["funding_ends_at"]
																																launched_at = Time.parse(project["funding_started_at"]).to_i
																																deadline = Time.parse(project["funding_ends_at"]).to_i
																																#~ Time.at(start) 
																																#~ Time.at(ends)

																				@pro = Project.where(:reference_project_id=>reference_project_id,:platform_from=>"INDIEGOGO")
																						if @pro.count <= 0
																										@creator= Creator.where(:reference_creator_id => reference_creator_id).first
																																if !@creator
																																				@creator = Creator.create(:reference_creator_id =>reference_creator_id, :name => creator_name)
																																				puts "Creating new creator"
																																				$logger.info "Creating new creator"
 																																		else
																																					puts "Using already existing creator"
																																					$logger.info "Using already existing creator"
																																				end
																															
																															
																									@project		=	@creator.projects.create(:reference_project_id => reference_project_id, :name => project_name,:state => state, :currency => currency, :currency_symbol => currency_symbol,:photo => photo,:location => project_location,:goal => goal,:urls => project_urls, :launched_at => launched_at, :deadline => deadline, :state_changed_at => state_changed_at,:kickstart_project_url=>kickstart_project_url,:category => category, :sub_category => sub_category,:platform_from=>"INDIEGOGO")
																									@project.pledged_backers.create(:pledged=>pledged, :backers_count=>backers_count,:pledges_created_at=>Time.now.in_time_zone("Pacific Time (US & Canada)"))
																												$logger.info "Assigned project to creator"
																							end
																																
																						rescue Exception => e
																						$logger.error "Error Occured - #{e.message}"
																						end																	

																												end

																								
																								
																		end    
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
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
  opts.banner = "Usage: ruby indiegogo_new_projects_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new indiegogo projects agent for building the projects' ) do |env|
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
indiegogo_new_projects_agent = IndiegogoNewProjectBuilderAgent.new(options)
indiegogo_new_projects_agent.start_processing
