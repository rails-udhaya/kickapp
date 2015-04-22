# -*- encoding : utf-8 -*-
class CreateCreators < ActiveRecord::Migration
  def change
    create_table :creators do |t|
        t.string :reference_creator_id,:name, :slug, :biography,:user_updated_at, :user_created_at
        t.text :backed_projects, :started_projects, :location, :urls, :avatar, :category_wheel,:kickstart_creator_url
        t.integer :started_projects_count, :unanswered_surveys_count, :backed_projects_count, :created_projects_count, :unread_messages_count
        t.boolean :notifiy, :social	
        
        t.timestamps
    end
  end
end
