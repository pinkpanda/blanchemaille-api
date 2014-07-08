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

%w(newspaper test).map do |route|
  before "/#{route}/*" do
  end
end

get '/newspapers' do
  @newspapers = Newspaper.all
  rabl :'newspapers/index', format: 'json'
end

get '/newspapers/:id' do
  @newspaper = Newspaper.find params[:id]
  rabl :'newspapers/show', format: 'json'
end

post '/newspapers' do
  @newspaper = Newspaper.new params

  if @newspaper.save
    redirect to("/newspapers/#{@newspaper.id}")
  else
    { callback: @newspaper.errors.full_messages }.to_json
  end
end

put '/newspapers/:id' do
  @newspaper = Newspaper.find params[:id]

  if @newspaper.update params
    redirect "/newspapers/#{@newspaper.id}"
  else
    { callback: @newspaper.errors.full_messages }.to_json
  end
end

delete '/newspapers/:id' do
  Newspaper.find(params[:id]).destroy
  redirect to('/newspapers')
end
