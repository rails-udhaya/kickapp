class AddContactInfoFromCreators < ActiveRecord::Migration
  def up
    add_column :creators, :website_url, :text
    add_column :creators, :facebook_full_name, :string
    add_column :creators, :facebook_url, :text
    add_column :creators, :facebook_message_url, :text
    add_column :creators, :twitter_url, :text
    add_column :creators, :email, :text
  end

  def down
      remove_column :creators, :website_url
      remove_column :creators, :facebook_full_name
      remove_column :creators, :facebook_url
      remove_column :creators, :facebook_message_url
      remove_column :creators, :twitter_url
      remove_column :creators, :email
  end
end
