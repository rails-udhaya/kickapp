# -*- coding: utf-8 -*-
#encoding: ASCII-8BIT
#~ https://www.kickstarter.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
require 'logger'
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
class CreateCategoryOneTime
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/CreateCategoryOneTime_agents.log", 'weekly')
        #~ $logger.level = Logger::DEBUG
        $logger.formatter = Logger::Formatter.new
    end
    
    def establish_db_connection
        # connect to the MySQL server
        get_db_connection(@options[:env])
    end
    
        def start_processing(s_projects)
         
            @live_projects = s_projects
            #~ puts @live_projects 
                       client = Kickscraper.client
                    @live_projects.each do |live_project|
                    #~ begin
                                encoding_options = {
                                :invalid           => :replace,  # Replace invalid byte sequences
                                :undef             => :replace,  # Replace anything not defined in ASCII
                                :replace           => '',        # Use a blank for those replacements
                                :universal_newline => true       # Always break lines with \n
                                }
                        $logger.info "Processing Project........ #{live_project.id}"
                        puts  "Processing Project........ #{live_project.id}"
                        #~ puts live_project.name
                       
                            @projects = client.search_projects(live_project.name)
                        puts live_project.kickstart_project_url
                        
                        
                        if @projects.empty?
                         sam=[]
                            temp_1 = live_project.name.encode(Encoding.find('ASCII'), encoding_options).split(" ")
                            temp_1.each do |t_1|
                                #~ puts t_1
                                begin
                                    sam.push(client.search_projects(t_1))
                                rescue
                                puts "Error Occured-2"
                                end
                               end
                            @projects = sam
                            @projects = @projects.flatten
                        end
                        #~ puts @projects.inspect
                        
                        @projects.each do |project|
                            category = ""
                            sub_category = ""
                            slug = ""
                            #~ puts live_project.id
                            slug =project.category.slug.split("/") if (project && project.category)
                            #~ puts slug
                                if (project.id.to_s == live_project.reference_project_id.to_s)
                                
                            if slug.length == 2
                             category = slug.first.split.map(&:capitalize).join(' ').gsub("'","''").strip()
                             sub_category = slug.last.split.map(&:capitalize).join(' ').gsub("'","''").strip()
                             elsif slug.length == 1
                                category = slug.first.split.map(&:capitalize).join(' ').gsub("'","''").strip()
                            end
                            
                            puts "category #{category}"
                            puts "sub_category #{sub_category}"
                            
                            $logger.info "category #{category}"
                            $logger.info "sub_category #{sub_category}"
                            
                                    live_project.update_attributes(:category => "#{category}", :sub_category => "#{sub_category}")
                                end
                                
                        end
                            #~ rescue Exception => e
                                #~ puts "Error Occured-1 - #{e.message}"
                                #~ $logger.error "Error Occured - #{e.message}"
                                #~ $logger.error e.backtrace
                                #~ sleep 5							
                            #~ end                    
                    
                    end
                   
           ActiveRecord::Base.clear_active_connections!
         end
         
         def multy_process
             $logger.info Time.now
              begin
            if $db_connection_established
                                s_project_1 = Project.where(:category=>nil,:platform_from=>"KICKSTARTER")
                                 start_processing(s_project_1)
           
            end    
              rescue Exception => e
              puts "Error Occured-thread - #{e.message}"
                          $logger.error "Error Occured - #{e.message}"
                          $logger.error e.backtrace
                          sleep 2									
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
  opts.banner = "Usage: ruby pledges_and_backers_agents.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the live projects agent for building the pledges' ) do |env|
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
create_category_one_time = CreateCategoryOneTime.new(options)
create_category_one_time.multy_process

