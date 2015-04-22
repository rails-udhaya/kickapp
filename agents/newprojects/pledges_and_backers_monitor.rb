#encoding: ASCII-8BIT


#~ https://www.kickstarter.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
require 'logger'
class PledgesAndBackersAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/pledges_and_backers_agents.log", 'weekly')
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
                    begin
                                encoding_options = {
                                :invalid           => :replace,  # Replace invalid byte sequences
                                :undef             => :replace,  # Replace anything not defined in ASCII
                                :replace           => '',        # Use a blank for those replacements
                                :universal_newline => true       # Always break lines with \n
                                }
                        $logger.info "Processing Project........ #{live_project.id}"
                        puts live_project.name
                       
                        if live_project.name.force_encoding("UTF-8").ascii_only?
                            @projects = client.search_projects(live_project.name)
                        else
                            puts "eeeeeeeeeeeeeee"
                             sam=[]
                            temp_1 = live_project.name.encode(Encoding.find('ASCII'), encoding_options).split(" ")
                            temp_1.each do |t_1|
                                #~ puts t_1
                                begin
                                    sam.push(client.search_projects(t_1))
                                rescue
                                end
                               end
                            @projects = sam
                            @projects = @projects.flatten
                        end
                        
                        @projects.each do |project|
                            backers_count = ""
                            pledged = ""
                            puts project.id.to_s 
                            puts live_project.reference_project_id.to_s
                                if (project.id.to_s == live_project.reference_project_id.to_s)
                                    
                                    #~ puts project.backers_count != live_project.pledged_backers.last.backers_count
                                    live_project.update_attributes(:state => "#{project.state}", :state_changed_at => "#{project.state_changed_at}")
                                    @dum = ""
                                        if live_project.pledged_backers.empty? 
                                            @dum = 0
                                        else
                                            @dum = live_project.pledged_backers.last.backers_count
                                        end
                                          #~ puts project.backers_count
                                          #~ puts @dum
                                        #~ puts project.backers_count != @dum
                                    if (project.backers_count.to_s != @dum.to_s)
                                        backers_count = project.backers_count
                                        pledged =  project.pledged
                                                        live_project.pledged_backers.create(:pledged=>pledged,:backers_count => backers_count,:pledges_created_at=>Time.now.in_time_zone("Pacific Time (US & Canada)"))
                                                        $logger.info "Created new backers entry"
                                                        $logger.info "backers_count..........#{backers_count}"
                                                        $logger.info "pledged..........#{pledged}" 
                                                        #~ puts "backers_count..........#{backers_count}"
                                                        #~ puts "pledged..........#{pledged}"
                                     end   
                                end
                                
                        end
                            rescue Exception => e
                                $logger.error "Error Occured - #{e.message}"
                                $logger.error e.backtrace
                                sleep 5							
                            end                    
                    
                    end
                   
           ActiveRecord::Base.clear_active_connections!
         end
         
         def multy_process
              begin
            if $db_connection_established
                while true do     
              
                   t_1 =  Thread.new{
                    s_project_1 = Project.where(:state=>"live")
                    start_processing(s_project_1)
                    }
                sleep 300
                   t_2 =  Thread.new{
                    #~ s_project_2 = Project.where(:state=>"live").order("id DESC")
                    s_project_2 = Project.where(:state=>"live")
                    start_processing(s_project_2)
                    }
                    
                    sleep 300
                    
                   t_3 =  Thread.new{
                    s_project_3 = Project.where(:state=>"live")
                    start_processing(s_project_3)
                    
                    }
              
                sleep 300           
                   t_4 =  Thread.new{
                    s_project_4 = Project.where(:state=>"live")
                    start_processing(s_project_4)
                    }
                sleep 300    
                
                   t_5 =  Thread.new{
                    s_project_5 = Project.where(:state=>"live")
                    start_processing(s_project_5)
                    }
                sleep 300    
                
                
                   t_6 =  Thread.new{
                    s_project_6 = Project.where(:state=>"live")
                    start_processing(s_project_6)
                    }
                sleep 300    
                
                
                   t_7 =  Thread.new{
                    s_project_7 = Project.where(:state=>"live")
                    start_processing(s_project_7)
                    }
                sleep 300    
                
                
                   t_8 =  Thread.new{
                    s_project_8 = Project.where(:state=>"live")
                    start_processing(s_project_8)
                    }
                sleep 300    
                
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
pledges_and_backers_agents = PledgesAndBackersAgent.new(options)
pledges_and_backers_agents.multy_process

