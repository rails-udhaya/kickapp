require "rubygems"
require 'logger' 


				Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
						$logger = Logger.new("#{File.dirname(__FILE__)}/logs/pledges_and_backers_monitor.log", 'weekly')
						#~ $logger.level = Logger::DEBUG
						$logger.formatter = Logger::Formatter.new

#~ while true do
pid_status_english = system("ps -aux | grep pledges_and_backers_agents.rb | grep -vq grep")
				if pid_status_english
						$logger.info ("nothing to do with pledges_and_backers_agents....")
				else
						$logger.info ("Process started pledges_and_backers_agents....")
						system("nohup bundle exec /usr/bin/ruby ../pledges_and_backers_agents.rb &")
				end
#~ sleep 300
#~ end