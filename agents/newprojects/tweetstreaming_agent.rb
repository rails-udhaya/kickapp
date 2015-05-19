require 'logger'

class TweetStreamingBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
								load_twitter_configuration
    end
    
    
				def load_twitter_configuration
        TweetStream.configure do |config|
												config.consumer_key       = 'uwqcto4cDD50x48NR1q8wVKCt'
												config.consumer_secret    = 'vdwKCUpssbpduF3IgAAfTEHYqpRCDECvrQIvx6eiG4A3MwdGl2'
												config.oauth_token        = '2902968606-fA5s5g9V1LAdwewNa8xcPCQQ5eUUAD1cTxG9H7G'
												config.oauth_token_secret = 'B7X4ihWLZa5Gu9xsUtAHGmkfkdmR9NbFFluYTnEInnTgN'
												config.auth_method        = :oauth
        end
    end
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/tweetstreaming_agent.log", 'weekly')
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
																												puts "11111111111"
																				begin
																										TweetStream::Client.new.track('@kickstarter') do |status|
																																if (status.text.downcase.include?("just backed") && status.text.downcase.include?("on @kickstarter"))
																																				tweet_id = ""
																																				tweet_text= ""
																																				tweeter_name = ""
																																				tweeter_screen_name = ""
																																				tweeter_user_id = ""
																																				kickstarter_project_name = ""
																																				tweet_text = status.text.gsub("'","''").strip()
																																				tweet_id = status.id
																																				tweeter_name = status.user.name.gsub("'","''").strip()
																																				tweeter_screen_name = "@"+status.user.screen_name.gsub("'","''").strip()
																																				tweeter_user_id = status.user.id
																																				kickstarter_project_name = tweet_text.split("just backed").last.split("on @Kickstarter").first.strip()
																																				$logger.info "Tweet id #{tweet_id} #{tweet_text}"
																																				if !status.retweet?
																																						data_exists = TwitterBacker.where("kickstarter_project_name = ?  && tweeter_screen_name = ?", "#{kickstarter_project_name}", "#{tweeter_screen_name}").length
																																								if data_exists == 0
																																														$logger.info "Creating tweeter"
																																												@twitter_backer = TwitterBacker.create(:tweet_text =>tweet_text, :tweet_id => tweet_id, :tweeter_name => tweeter_name, :tweeter_screen_name => tweeter_screen_name, :tweeter_user_id => tweeter_user_id, :kickstarter_project_name => kickstarter_project_name)
																																												#~ sleep 5
																																										end
																																				end		
																																end
																										end
																				rescue Exception => e
																				puts "error"
																								$logger.error "Error Occured - #{e.message}"
																								$logger.error e.backtrace
																								sleep 900
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
  opts.banner = "Usage: ruby newprojects_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new Tweet stream agent for collecting the new backers' ) do |env|
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
require File.expand_path('../twitter_configurations', __FILE__)
newprojects_agent = TweetStreamingBuilderAgent.new(options)
newprojects_agent.start_processing
