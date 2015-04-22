# -*- encoding : utf-8 -*-
class CreatePledgedBackers < ActiveRecord::Migration
  def change
    create_table :pledged_backers do |t|
      t.integer :pledged, :backers_count, :project_id
      t.datetime :pledges_created_at
      t.timestamps
    end
  end
end
