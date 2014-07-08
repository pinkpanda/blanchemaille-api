require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'rabl'

require './models.rb'


config = YAML.load(File.read('config/database.yml'))
RACK_ENV ||= ENV['RACK_ENV'] || 'development'

ActiveRecord::Base.establish_connection config[RACK_ENV]

Rabl.configure do |config|
  config.include_json_root  = false
  config.include_child_root = false
end


before do
  content_type 'application/json'
end

get '/' do
  @pages = Page.all
  rabl :index, format: 'json'
end
