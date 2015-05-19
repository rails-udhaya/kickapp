class CreateTwitterBackers < ActiveRecord::Migration
  def change
    create_table :twitter_backers do |t|
      t.string :tweeter_name, :tweeter_screen_name
      t.text :tweet_text, :kickstarter_project_name, :tweet_id, :tweeter_user_id
      t.timestamps
    end
  end
end


