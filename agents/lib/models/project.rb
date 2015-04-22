# -*- encoding : utf-8 -*-
class Project < ActiveRecord::Base
  attr_accessible :reference_project_id, :name, :slug, :blurb, :state, :currency, :currency_symbol, :country, :country_short_name, :country_long_name, :rewards, :photo, :video, :embed, :location, :friends, :urls, :comments_count, :updates_count, :goal, :is_started, :is_backing, :launched_at, :project_updated_at, :deadline, :state_changed_at, :kickstart_project_url
  serialize	:photo
  serialize :video
  serialize :embed
  serialize :location
  serialize :friends
  serialize :urls
  belongs_to :creator
  has_many :pledged_backers
end
