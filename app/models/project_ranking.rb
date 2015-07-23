class ProjectRanking < ActiveRecord::Base
   attr_accessible :reference_project_id, :ks_discover_query, :ranking, :name, :kickstart_project_url
end
