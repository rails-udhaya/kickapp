# -*- encoding : utf-8 -*-
#~ https://www.kickstarter.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
require 'logger'
class NewProjectBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/newprojects_agent.log", 'weekly')
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
																		#~ $logger.info Creator.first
																						while true do
																								
																								client = Kickscraper.client
																								projects = client.newest_projects
																								
																								projects.each do |project|
																										begin
																										$logger.info  project.id
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

																																reference_creator_id=project.creator.id
																																creator_name=project.creator.name.gsub("'","''").strip()
																																user_updated_at=project.creator.user_updated_at
																																social=project.creator.social


																																reference_project_id = project.id
																																project_name= project.name.gsub("'","''").strip()
																																state=project.state
																																currency= project.currency
																																currency_symbol= project.currency_symbol
																																photo= project.photo
																																project_location = project.location
																																backers_count=project.backers_count
																																goal=project.goal
																																pledged= project.pledged
																																project_urls= project.urls
																																puts kickstart_project_url= project.urls.web.project.gsub("?ref=newest","").strip()
																																launched_at=project.launched_at
																																deadline=project.deadline
																																state_changed_at=project.state_changed_at
																																slug =project.category.slug.split("/")
																																
																																#~ For category
																																		if slug.length == 2
																																				category = slug.first.split.map(&:capitalize).join(' ').gsub("'","''").strip()
																																				sub_category = slug.last.split.map(&:capitalize).join(' ').gsub("'","''").strip()
																																		elsif slug.length == 1
																																				category = slug.first.split.map(&:capitalize).join(' ').gsub("'","''").strip()
																																		end
																				
																				@pro = Project.where(:reference_project_id=>reference_project_id)
																						if @pro.count <= 0
																										@creator= Creator.where(:reference_creator_id => reference_creator_id).first
																																if !@creator
																																				@creator = Creator.create(:reference_creator_id =>reference_creator_id, :name => creator_name)
																																				$logger.info "Creating new creator"
 																																		else
																																					$logger.info "Using already existing creator"
																																				end
																															
																															
																									@project		=	@creator.projects.create(:reference_project_id => reference_project_id, :name => project_name,:state => state, :currency => currency, :currency_symbol => currency_symbol,:photo => photo,:location => project_location,:goal => goal,:urls => project_urls, :launched_at => launched_at, :deadline => deadline, :state_changed_at => state_changed_at,:kickstart_project_url=>kickstart_project_url,:category => category, :sub_category => sub_category,:platform_from=>"KICKSTARTER")
																									@project.pledged_backers.create(:pledged=>pledged, :backers_count=>backers_count,:pledges_created_at=>Time.now.in_time_zone("Pacific Time (US & Canada)"))
																												$logger.info "Assigned project to creator"
																							end
																																
																						rescue Exception => e
																						$logger.error "Error Occured - #{e.message}"
																						#~ sleep 600									
																						end																	
																								end
																										sleep 600									
																																													
																				end
																		end    
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
														sleep 300									
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
newprojects_agent = NewProjectBuilderAgent.new(options)
newprojects_agent.start_processing
