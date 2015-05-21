# -*- encoding : utf-8 -*-
class Project < ActiveRecord::Base
  attr_accessible :reference_project_id, :name, :state, :currency, :currency_symbol,:photo, :location,:urls, :goal, :launched_at, :deadline, :state_changed_at, :kickstart_project_url, :category, :sub_category
  serialize :location
  serialize :photo
  serialize :urls
  belongs_to :creator
  has_many :pledged_backers
end


