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
																																creator_slug= "" 
																																biography= "" 
																																backed_projects= "" 
																																started_projects= "" 
																																creator_location= "" 
																																creator_urls= "" 
																																avatar= "" 
																																category_wheel= "" 
																																started_projects_count= "" 
																																unanswered_surveys_count= "" 
																																backed_projects_count= "" 
																																created_projects_count= "" 
																																unread_messages_count= "" 
																																notifiy= "" 
																																social= "" 
																																kickstart_creator_url = ""
																																
																																#~ projects variables
																																reference_project_id="" 
																																project_name="" 
																																project_slug="" 
																																blurb="" 
																																state="" 
																																currency="" 
																																currency_symbol="" 
																																country="" 
																																country_short_name="" 
																																country_long_name="" 
																																rewards="" 
																																photo="" 
																																video="" 
																																embed="" 
																																project_location="" 
																																friends="" 
																																creator_id="" 
																																comments_count="" 
																																updates_count="" 
																																backers_count="" 
																																goal="" 
																																pledged="" 
																																project_urls="" 
																																is_started="" 
																																is_backing="" 
																																launched_at="" 
																																project_updated_at="" 
																																deadline="" 
																																state_changed_at=""
																																kickstart_project_url = ""

																																reference_creator_id=project.creator.id
																																creator_name=project.creator.name
																																creator_=project.creator.slug
																																biography=project.creator.biography
																																backed_projects=project.creator.backed_projects
																																started_projects=project.creator.started_projects
																																creator_location=project.creator.location
																																creator_urls=project.creator.urls
																																puts kickstart_creator_url = project.creator.urls.web.user
																																avatar=project.creator.avatar
																																category_wheel=project.creator.category_wheel
																																started_projects_count=project.creator.started_projects_count
																																unanswered_surveys_count=project.creator.unanswered_surveys_count
																																backed_projects_count=project.creator.backed_projects_count
																																created_projects_count=project.creator.created_projects_count
																																unread_messages_count=project.creator.unread_messages_count
																																notifiy=project.creator.notifiy
																																social=project.creator.social
																																user_updated_at=project.creator.user_updated_at
																																social=project.creator.social


																																reference_project_id = project.id
																																project_name= project.name
																																project_slug= project.slug
																																blurb= project.blurb
																																state=project.state
																																currency= project.currency
																																currency_symbol= project.currency_symbol
																																country= project.country
																																country_short_name= project.country_short_name
																																country_long_name= project.country_long_name
																																rewards= project.rewards
																																photo= project.photo
																																video=project.video
																																embed=project.embed
																																project_location = project.location
																																friends= project.friends
																																comments_count = project.comments.count
																																updates_count=project.updates.count if !project.updates.nil?
																																backers_count=project.backers_count
																																goal=project.goal
																																pledged= project.pledged
																																project_urls= project.urls
																																puts kickstart_project_url= project.urls.web.project.gsub("?ref=newest","").strip()
																																is_started= project.is_started
																																is_backing=project.is_backing
																																launched_at=project.launched_at
																																project_updated_at=project.updated_at
																																deadline=project.deadline
																																state_changed_at=project.state_changed_at

																				@pro = Project.where(:reference_project_id=>reference_project_id)
																						if @pro.count <= 0
																										@creator= Creator.where(:reference_creator_id => reference_creator_id).first
																																if !@creator
																																				@creator = Creator.create(:reference_creator_id =>reference_creator_id, :name => creator_name, :slug=>creator_slug, :biography=>biography, :backed_projects=>backed_projects, :started_projects=>started_projects, :location => creator_location, :urls => creator_urls, :avatar=>avatar, :category_wheel=>category_wheel, :started_projects_count=>started_projects_count, :unanswered_surveys_count=>unanswered_surveys_count, :backed_projects_count=>backed_projects_count, :created_projects_count=>created_projects_count, :unread_messages_count=>unread_messages_count, :notifiy=>notifiy, :social=>social, :user_updated_at=>user_updated_at, :social=>social, :kickstart_creator_url => kickstart_creator_url)
																																				$logger.info "Creating new creator"
 																																		else
																																					$logger.info "Using already existing creator"
																																				end
																															
																															
																									@project		=	@creator.projects.create(:reference_project_id => reference_project_id, :name => project_name, :slug => project_slug, :blurb => blurb, :state => state, :currency => currency, :currency_symbol => currency_symbol, :country => country, :country_short_name => country_short_name, :country_long_name => country_long_name, :rewards => rewards, :photo => photo, :video => video, :embed => embed, :location => project_location, :friends => friends, :comments_count => comments_count, :updates_count => updates_count, :goal => goal,:urls => project_urls, :is_started => is_started, :is_backing => is_backing, :launched_at => launched_at, :project_updated_at => project_updated_at, :deadline => deadline, :state_changed_at => state_changed_at,:kickstart_project_url=>kickstart_project_url)
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
														#~ sleep 600									
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
