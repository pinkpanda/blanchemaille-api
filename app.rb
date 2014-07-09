require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'rabl'

require './helpers.rb'
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

%w(newspaper organization page partner work).map do |model|
  before "/#{model}s/:id" do
    instance_variable_set(:"@#{model}", model.classify.constantize.find_by_id(params[:id]))
    error 404 unless instance_variable_get(:"@#{model}")
  end
end


# Newspapers

get '/newspapers' do
  @newspapers = Newspaper.all
  rabl :'newspapers/index', format: 'json'
end

get '/newspapers/:id' do
  rabl :'newspapers/show', format: 'json'
end

post '/newspapers' do
  @newspaper = Newspaper.new permit(request.params, Newspaper)

  if @newspaper.save
    rabl :'newspapers/show', format: 'json'
  else
    { messages: @newspaper.errors.full_messages }.to_json
  end
end

put '/newspapers/:id' do
  if @newspaper.update permit(request.params, Newspaper)
    rabl :'newspapers/show', format: 'json'
  else
    { messages: @newspaper.errors.full_messages }.to_json
  end
end

delete '/newspapers/:id' do
  @newspaper.destroy
end


# Organizations

get '/organizations' do
  @organizations = Organization.all
  rabl :'organizations/index', format: 'json'
end

get '/organizations/:id' do
  rabl :'organizations/show', format: 'json'
end

post '/organizations' do
  @organization = Organization.new permit(request.params, Organization)

  if @organization.save
    rabl :'organizations/show', format: 'json'
  else
    { messages: @organization.errors.full_messages }.to_json
  end
end

put '/organizations/:id' do
  if @organization.update permit(request.params, Organization)
    rabl :'organizations/show', format: 'json'
  else
    { messages: @organization.errors.full_messages }.to_json
  end
end

delete '/organizations/:id' do
  @organization.destroy
end


# Pages

get '/pages' do
  @pages = Page.all
  rabl :'pages/index', format: 'json'
end

get '/pages/:id' do
  rabl :'pages/show', format: 'json'
end

post '/pages' do
  @page = Page.new permit(request.params, Page)

  if @page.save
    rabl :'pages/show', format: 'json'
  else
    { messages: @page.errors.full_messages }.to_json
  end
end

put '/pages/:id' do
  if @page.update permit(request.params, Page)
    rabl :'pages/show', format: 'json'
  else
    { messages: @page.errors.full_messages }.to_json
  end
end

delete '/pages/:id' do
  @page.destroy
end


# Partners

get '/partners' do
  @partners = Partner.all
  rabl :'partners/index', format: 'json'
end

get '/partners/:id' do
  rabl :'partners/show', format: 'json'
end

post '/partners' do
  @partner = Partner.new permit(request.params, Partner)

  if @partner.save
    rabl :'partners/show', format: 'json'
  else
    { messages: @partner.errors.full_messages }.to_json
  end
end

put '/partners/:id' do
  if @partner.update permit(request.params, Partner)
    rabl :'partners/show', format: 'json'
  else
    { messages: @partner.errors.full_messages }.to_json
  end
end

delete '/partners/:id' do
  @partner.destroy
end


# Works

get '/works' do
  @works = Work.all
  rabl :'works/index', format: 'json'
end

get '/works/:id' do
  rabl :'works/show', format: 'json'
end

post '/works' do
  @work = Work.new permit(request.params, Work)

  if @work.save
    rabl :'works/show', format: 'json'
  else
    { messages: @work.errors.full_messages }.to_json
  end
end

put '/works/:id' do
  if @work.update permit(request.params, Work)
    rabl :'works/show', format: 'json'
  else
    { messages: @work.errors.full_messages }.to_json
  end
end

delete '/works/:id' do
  @work.destroy
end
