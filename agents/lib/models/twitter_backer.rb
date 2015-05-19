class TwitterBacker < ActiveRecord::Base
  # attr_accessible :title, :body
    attr_accessible :tweet_id, :tweet_text, :tweeter_name, :tweeter_screen_name, :tweeter_user_id, :kickstarter_project_name
end
