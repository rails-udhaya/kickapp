# -*- encoding : utf-8 -*-
class Creator < ActiveRecord::Base
  attr_accessible :reference_creator_id, :name, :slug, :biography, :backed_projects, :started_projects, :location, :urls, :avatar, :category_wheel, :started_projects_count, :unanswered_surveys_count, :backed_projects_count, :created_projects_count, :unread_messages_count, :notifiy, :social,:kickstart_creator_url
  serialize	:backed_projects
  serialize :started_projects
  serialize :location
  serialize :urls
  serialize :avatar
  serialize :category_wheel
  	has_many :projects
end
