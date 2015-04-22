# -*- encoding : utf-8 -*-
class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
          t.string :reference_project_id,:name,:slug, :blurb, :state, :currency, :currency_symbol, :country, :country_short_name, :country_long_name, :rewards,:launched_at, :project_updated_at, :deadline, :state_changed_at
          t.text :photo, :video, :embed, :location, :friends, :urls,:kickstart_project_url
          t.integer :creator_id, :comments_count, :updates_count
          t.float :goal
          t.boolean :is_started, :is_backing
          t.timestamps
    end
  end
end
