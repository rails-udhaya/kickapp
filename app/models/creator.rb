# -*- encoding : utf-8 -*-
class Creator < ActiveRecord::Base
  attr_accessible :reference_creator_id, :name
  	has_many :projects
end

