# -*- encoding : utf-8 -*-
require 'rubygems'
require 'logger'
require 'active_record'
require 'optparse'
require 'mysql2'
require 'tweetstream'


ActiveRecord::Base.default_timezone = :utc
require File.expand_path('../../lib/config/database_connection', __FILE__)
require File.expand_path('../../lib/models/twitter_backer', __FILE__)

