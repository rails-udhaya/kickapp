# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
		
		def index
				#~ @projects = Project.find(:all , :order => "id DESC", :limit => 24)
		end
		
		
		def search
				sql = ActiveRecord::Base.connection();
  		if(params[:searchs] && params[:searchs] != "")
												@project = Project.find_by_kickstart_project_url(params[:searchs])
												if @project
														#Pledged data
																		@project_pledged_backers = PledgedBacker.find_by_sql("select pledged,backers_count,DATE(CONVERT_TZ( pledges_created_at ,  'US/Pacific',  'US/Mountain' )) as pledges_created_at from pledged_backers where project_id = '#{@project.id}'")
																		#~ @pledges = sql.execute("SELECT pledged, DATE(pledges_created_at) FROM pledged_backers where project_id = '#{@project.id}' GROUP BY DATE(pledged_backers.pledges_created_at);") rescue {}
																		#~ @pledges = sql.execute("SELECT min(pledged),max(pledged), DATE(pledges_created_at) FROM pledged_backers where project_id = '#{@project.id}' GROUP BY DATE(pledged_backers.pledges_created_at);") rescue {}
																		@pledges = sql.execute("SELECT min(pledged),max(pledged), DATE(CONVERT_TZ( pledges_created_at ,  'US/Pacific',  'US/Mountain' )) FROM pledged_backers where project_id = '#{@project.id}' GROUP BY  DATE(CONVERT_TZ(pledged_backers.pledges_created_at ,  'US/Pacific',  'US/Mountain' ));") rescue {}
																		@pledges_graph = @pledges.each_with_index.collect { |item,index| 
																		puts "ddddddddddddddddddddddddddddddddddddd #{index}"
																		if index == 0
																		{:date => item[2], :value => (item[1].to_i).to_s} 
																		else
																		{:date => item[2], :value => (item[1].to_i-item[0].to_i).to_s} 
																		end
																		}
																				@goal_date_count = ((DateTime.strptime(@project.deadline,'%s').to_date - @pledges_graph.last[:date]).to_i - 1)
																				for i in 1..@goal_date_count
																						@pledges_graph << {:date =>(@pledges_graph.last[:date] + 1), :value => ""}
																				end
																		#~ @pledges_graph_end = {:date =>DateTime.strptime(@project.deadline,'%s').in_time_zone("Pacific Time (US & Canada)").to_date, :value => ""}
																		#~ @pledges_graph<< @pledges_graph_end
																		@full_pledge_graph = @pledges_graph.to_json
																		
								end
				end
										
				
				if  (params[:searchs] && @project.blank?)
								flash[:notice] = 'Invalid Url'
						end
end
		
		def show
				@project = Project.find(params[:id])
				@creator = @project.creator
		end
		
		
		def demo_embed
		end
		
end
