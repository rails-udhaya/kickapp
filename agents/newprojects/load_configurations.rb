# -*- encoding : utf-8 -*-
require 'rubygems'
require 'logger'
require 'active_record'
require 'optparse'
require 'kickscraper'
require 'mysql2'



ActiveRecord::Base.default_timezone = :utc
require File.expand_path('../../lib/config/database_connection', __FILE__)

#~ required the ActiveRecord based classes to easilly access our DB tables.
require File.expand_path('../../lib/models/creator', __FILE__)
require File.expand_path('../../lib/models/project', __FILE__)
require File.expand_path('../../lib/models/pledged_backer', __FILE__)
require File.expand_path('../../lib/models/twitter_backer', __FILE__)

