class RemoveUnwantedFieldsFromCreator < ActiveRecord::Migration
  def up
    remove_column :creators, :slug
    remove_column :creators, :user_updated_at
    remove_column :creators, :backed_projects
    remove_column :creators, :started_projects
    remove_column :creators, :location
    remove_column :creators, :urls
    remove_column :creators, :avatar
    remove_column :creators, :kickstart_creator_url
    remove_column :creators, :category_wheel
    remove_column :creators, :biography
    remove_column :creators, :started_projects_count
    remove_column :creators, :unanswered_surveys_count
    remove_column :creators, :backed_projects_count
    remove_column :creators, :created_projects_count
    remove_column :creators, :unread_messages_count
    remove_column :creators, :notifiy
    remove_column :creators, :social
    remove_column :creators, :user_created_at
    
  end

  def down
  add_column :creators, :slug, :string
  add_column :creators, :user_updated_at, :string
  add_column :creators, :user_created_at, :string
  
    add_column :creators, :backed_projects, :text
    add_column :creators, :started_projects, :text
    add_column :creators, :location, :text
    add_column :creators, :urls, :text
    add_column :creators, :avatar, :text
    add_column :creators, :category_wheel, :text
    add_column :creators, :kickstart_creator_url, :text
    add_column :creators, :biography, :text
  
      add_column :creators, :started_projects_count, :integer
      add_column :creators, :unanswered_surveys_count, :integer
      add_column :creators, :backed_projects_count, :integer
      add_column :creators, :created_projects_count, :integer
      add_column :creators, :unread_messages_count, :integer
      
      add_column :creators, :social, :boolean
      add_column :creators, :notifiy, :boolean
  end
end

