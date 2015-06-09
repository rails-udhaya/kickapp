require "rubygems"
require 'logger' 


				Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
						$logger = Logger.new("#{File.dirname(__FILE__)}/logs/indiegogo_pledges_and_backers_monitor.log", 'weekly')
						#~ $logger.level = Logger::DEBUG
						$logger.formatter = Logger::Formatter.new

#~ while true do
pid_status_english = system("ps -aux | grep i_p_and_b.rb | grep -vq grep")
				if pid_status_english
						$logger.info ("nothing to do with indiegogo_pledges_and_backers....")
				else
						$logger.info ("Process started indiegogo_pledges_and_backers_agents....")
						#~ system("nohup bundle exec /usr/bin/ruby ../i_p_and_b.rb &")
						 system("nohup bundle exec /usr/bin/ruby /var/www/apps/kickapp/current/agents/newprojects/i_p_and_b.rb -e production &")

				end
#~ sleep 300
#~ end