require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/croon'
require 'pony'
require 'multi_json'
require 'rabl'

require './modules.rb'
require './helpers.rb'
require './models.rb'


Rabl.configure do |config|
  config.include_json_root  = false
  config.include_child_root = false
end


before /^(?!\/docs)/ do
  content_type :json
  request.params.merge! json_body_params
end

%w(newspaper organization page partner work).map do |model|
  before "/#{model}s/:id" do
    instance_variable_set(:"@#{model}", model.classify.constantize.find_by_id(params[:id]))
    @page = Page.find_by_slug(params[:id]) if !instance_variable_get(:"@#{model}") && model === 'page'

    error 404 unless instance_variable_get(:"@#{model}")
  end
end

# Show docs.
get '/' do
  redirect '/docs'
end

# Send an email.
post '/contact' do
  Pony.mail to: request.params[:to],
            from: request.params[:from],
            subject: request.params[:subject],
            body: request.params[:body]
end

# Get all newspapers.
get '/newspapers' do
  @newspapers = Newspaper.all
  rabl :'newspapers/index', format: 'json'
end

# Get a newspaper.
#
# @param <id> the id of the newspaper you search for
get '/newspapers/:id' do
  rabl :'newspapers/show', format: 'json'
end

# Add a newspaper.
post '/newspapers' do
  @newspaper = Newspaper.new permit(request.params, Newspaper)

  if @newspaper.save
    rabl :'newspapers/show', format: 'json'
  else
    status 400
    { message: @newspaper.errors.full_messages }.to_json
  end
end

# Update a newspaper.
#
# @param <id> the id of the newspaper to update
put '/newspapers/:id' do
  if @newspaper.update permit(request.params, Newspaper)
    rabl :'newspapers/show', format: 'json'
  else
    status 400
    { message: @newspaper.errors.full_messages }.to_json
  end
end

# Delete a newspaper.
#
# @param <id> the id of the newspaper to delete
delete '/newspapers/:id' do
  @newspaper.destroy
end


# Get all organizations.
get '/organizations' do
  @organizations = Organization.all
  rabl :'organizations/index', format: 'json'
end

# Get an organization.
#
# @param <id> the id of the organization you search for
get '/organizations/:id' do
  rabl :'organizations/show', format: 'json'
end

# Add an organization.
post '/organizations' do
  @organization = Organization.new permit(request.params, Organization)

  if @organization.save
    rabl :'organizations/show', format: 'json'
  else
    status 400
    { message: @organization.errors.full_messages }.to_json
  end
end

# Update an organization.
#
# @param <id> the id of the organization to update
put '/organizations/:id' do
  if @organization.update permit(request.params, Organization)
    rabl :'organizations/show', format: 'json'
  else
    status 400
    { message: @organization.errors.full_messages }.to_json
  end
end

# Delete an organization.
#
# @param <id> the id of the organization to delete
delete '/organizations/:id' do
  @organization.destroy
end


# Get all pages.
get '/pages' do
  @pages = Page.all
  rabl :'pages/index', format: 'json'
end

# Get a page.
#
# @param <id> the id or slug of the page you search for
get '/pages/:id' do
  rabl :'pages/show', format: 'json'
end

# Add a page.
post '/pages' do
  @page = Page.new permit(request.params, Page)

  if @page.save
    rabl :'pages/show', format: 'json'
  else
    status 400
    { message: @page.errors.full_messages }.to_json
  end
end

# Update a page.
#
# @param <id> the id of the page to update
put '/pages/:id' do
  if @page.update permit(request.params, Page)
    rabl :'pages/show', format: 'json'
  else
    status 400
    { message: @page.errors.full_messages }.to_json
  end
end

# Delete a page.
#
# @param <id> the id of the page to delete
delete '/pages/:id' do
  @page.destroy
end


# Get all partners.
get '/partners' do
  @partners = Partner.all
  rabl :'partners/index', format: 'json'
end

# Get a partner.
#
# @param <id> the id of the partner you search for
get '/partners/:id' do
  rabl :'partners/show', format: 'json'
end

# Add a partner.
post '/partners' do
  @partner = Partner.new permit(request.params, Partner)

  if @partner.save
    rabl :'partners/show', format: 'json'
  else
    status 400
    { message: @partner.errors.full_messages }.to_json
  end
end

# Update a partner.
#
# @param <id> the id of the partner to update
put '/partners/:id' do
  if @partner.update permit(request.params, Partner)
    rabl :'partners/show', format: 'json'
  else
    status 400
    { message: @partner.errors.full_messages }.to_json
  end
end

# Delete a partner.
#
# @param <id> the id of the partner to delete
delete '/partners/:id' do
  @partner.destroy
end


# Get all works.
get '/works' do
  @works = Work.all
  rabl :'works/index', format: 'json'
end

# Get a work.
#
# @param <id> the id of the work you search for
get '/works/:id' do
  rabl :'works/show', format: 'json'
end

# Add a work.
post '/works' do
  @work = Work.new permit(request.params, Work)

  if @work.save
    rabl :'works/show', format: 'json'
  else
    status 400
    { message: @work.errors.full_messages }.to_json
  end
end

# Update a work.
#
# @param <id> the id of the work to update
put '/works/:id' do
  if @work.update permit(request.params, Work)
    rabl :'works/show', format: 'json'
  else
    status 400
    { message: @work.errors.full_messages }.to_json
  end
end

# Delete a work.
#
# @param <id> the id of the work to delete
delete '/works/:id' do
  @work.destroy
end

not_found do
  { message: 'Not found' }.to_json
end
