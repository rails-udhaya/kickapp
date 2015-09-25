# -*- encoding : utf-8 -*-
class PledgedBacker < ActiveRecord::Base
  # attr_accessible :title, :body
      attr_accessible :pledged, :backers_count, :pledges_created_at, :increase_pledges, :increase_backers
      belongs_to :project
end
