# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
		
		def index
				#~ @projects = Project.find(:all , :order => "id DESC", :limit => 24)
		end
		
		
		def search
  		if(params[:searchs] && params[:searchs] != "")
												@project = Project.find_by_kickstart_project_url(params[:searchs])
												@project_pledged_backers = @project.pledged_backers if @project
						
				end
				
				if  (params[:searchs] && @project.blank?)
								flash[:notice] = 'Invalid Url'
						end
end
		
		def show
				@project = Project.find(params[:id])
				@creator = @project.creator
		end
end
