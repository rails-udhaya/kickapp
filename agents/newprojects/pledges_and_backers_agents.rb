# -*- coding: utf-8 -*-
#encoding: ASCII-8BIT
#~ https://www.kickstarter.com/projects/350061949/lapis-lazuli-stones-for-enlightenment-truth-and-de.json
#~ https://github.com/markolson/kickscraper/issues/16
require 'logger'
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
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
                       client = Kickscraper.client
                    @live_projects.each do |live_project|
                    begin
                                
                        $logger.info "Processing Project........ #{live_project.id}"

                             uri = URI.parse("#{live_project.kickstart_project_url}/stats.json")
                              http = Net::HTTP.new(uri.host, uri.port)
                              http.use_ssl = true
                              http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
                              response = http.get(uri.request_uri)
                              
                              if(response.code != "200")
                               sleep 5
                               o = 1
                               tot = 4
                               while o <= tot  do
                                 uri = URI.parse("#{live_project.kickstart_project_url}/stats.json")
                                 http = Net::HTTP.new(uri.host, uri.port)
                                 http.use_ssl = true
                                 http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
                                 response = http.get(uri.request_uri)
                                 $logger.info "code in while....#{response.code}.... #{live_project.id}"
                                 o=o+1
                                 if(response.code == "200")
                                  o=5
                                 end
                                end
                              end
                              
                             ou = JSON.parse(response.body)
                             project = ou["project"]
                             $logger.info "#{project}"
                           
                            backers_count = ""
                            pledged = ""

                            puts live_project.id
                            #~ puts live_project.pledged_backers.last.backers_count
                            #~ puts live_project.pledged_backers.last.pledged
                                if (project["id"].to_s == live_project.reference_project_id.to_s)
                                    
                                    live_project.update_attributes(:state => "#{project["state"]}", :state_changed_at => "#{project["state_changed_at"]}")
                                    @dum = ""
                                        if live_project.pledged_backers.empty? 
                                            @dum = 0
                                        else
                                            @dum = live_project.pledged_backers.last.backers_count
                                        end
                                    if (project["backers_count"].to_s != @dum.to_s)
                                        backers_count = project["backers_count"]
                                        pledged =  project["pledged"]
                                        sleep 1
                                                        live_project.pledged_backers.create(:pledged=>pledged,:backers_count => backers_count,:pledges_created_at=>Time.now.in_time_zone("Pacific Time (US & Canada)"))
                                                        $logger.info "Created new backers entry"
                                                        $logger.info "backers_count..........#{backers_count}"
                                                        $logger.info "pledged..........#{pledged}" 
                                     end   
                                end
                                live_project.touch
                            rescue Exception => e
                                puts "Error Occured-1 - #{e.message}"
                                $logger.error "Error Occured-1 - #{e.message}"
                                $logger.error e.backtrace
                                #~ sleep 2							
                            end                    
                    
                    end
                   
           #~ ActiveRecord::Base.clear_active_connections!
           $logger.info Time.now
         end
         
         def multy_process
             $logger.info Time.now
              begin
            if $db_connection_established
              
              
              

                                cnt = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").count / 5
                                s_project_1 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").limit(cnt)
                                s_project_2 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt).limit(cnt)
                                s_project_3 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt).limit(cnt)
                                s_project_4 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt+cnt).limit(cnt)
                                s_project_5 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt+cnt+cnt).limit(cnt)
                                #~ s_project_6 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt+cnt+cnt+cnt).limit(cnt)
                                #~ s_project_7 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt+cnt+cnt+cnt+cnt).limit(cnt)
                                #~ s_project_8 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt+cnt+cnt+cnt+cnt+cnt).limit(cnt)
                                #~ s_project_9 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt+cnt+cnt+cnt+cnt+cnt+cnt).limit(cnt)
                                #~ s_project_10 = Project.where(:state=>"live",:platform_from=>"KICKSTARTER").offset(cnt+cnt+cnt+cnt+cnt+cnt+cnt+cnt+cnt)


#~ puts  s_project_1.collect{|x| x.id}
#~ puts  s_project_2.collect{|x| x.id}
#~ puts  s_project_3.collect{|x| x.id}
#~ puts  s_project_4.collect{|x| x.id}
#~ puts  s_project_5.collect{|x| x.id}
#~ puts  s_project_6.collect{|x| x.id}
#~ puts  s_project_7.collect{|x| x.id}
#~ puts  s_project_8.collect{|x| x.id}
#~ puts  s_project_9.collect{|x| x.id}
#~ puts  s_project_10.collect{|x| x.id}

                
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
                    t_3 =  Thread.new{
                   $logger.info "thread 3"
                    start_processing(s_project_3)
                    }
               sleep 5
                    t_4 =  Thread.new{
                   $logger.info "thread 4"
                    start_processing(s_project_4)
                    }
               sleep 5     
                    t_5 =  Thread.new{
                   $logger.info "thread 5"
                    start_processing(s_project_5)
                    }
                    
                    #~ t_6 =  Thread.new{
                   #~ puts "thread 6"
                    #~ start_processing(s_project_6)
                    #~ }
                    
                    #~ t_7 =  Thread.new{
                   #~ puts "thread 7"
                    #~ start_processing(s_project_7)
                    #~ }
                    
                    #~ t_8 =  Thread.new{
                   #~ puts "thread 8"
                    #~ start_processing(s_project_8)
                    #~ }
                    
                    #~ t_9 =  Thread.new{
                   #~ puts "thread 9"
                    #~ start_processing(s_project_9)
                    #~ }
                    
                    #~ t_10 =  Thread.new{
                   #~ puts "thread 10"
                    #~ start_processing(s_project_10)
                    #~ }
                    
                t_1.join
                t_2.join
                t_3.join
                t_4.join
                t_5.join
                #~ t_6.join
                #~ t_7.join
                #~ t_8.join
                #~ t_9.join
                #~ t_10.join
           
            end    
              rescue Exception => e
              puts "Error Occured-thread - #{e.message}"
                          $logger.error "Error Occured - #{e.message}"
                          $logger.error e.backtrace
                          #~ sleep 2									
                      ensure
                          $logger.close
                          #~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
                          #~ ActiveRecord::Base.clear_active_connections!
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

