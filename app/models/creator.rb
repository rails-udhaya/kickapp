# -*- encoding : utf-8 -*-
class Creator < ActiveRecord::Base
  attr_accessible :reference_creator_id, :name, :website_url, :facebook_full_name, :facebook_url, :facebook_message_url, :twitter_url, :email
  has_many :projects
end

