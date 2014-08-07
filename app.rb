require 'bundler/setup'
require 'dotenv'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/croon'
require 'friendly_id'
require 'pony'
require 'multi_json'
require 'rabl'
require 'securerandom'
require 'digest/md5'

require './modules.rb'
require './helpers.rb'
require './models.rb'


Dotenv.load

Rabl.configure do |config|
  config.include_json_root  = false
  config.include_child_root = false
end


before /^(?!\/docs)/ do
  content_type :json
  request.params.merge! json_body_params
end

set(:check) do |name|
  condition do
    error 401 unless send(name)
  end
end

%w(event image newspaper organization page partner user work).map do |model|
  before "/#{model}s/:id" do
    if %w(image page user).include? model
      instance_variable_set(:"@#{model}", model.classify.constantize.find_by_id(params[:id]))
      @page = Page.find_by_slug(params[:id]) if model == 'page' && !instance_variable_get(:"@#{model}")
    else
      begin
        instance_variable_set(:"@#{model}", model.classify.constantize.friendly.find(params[:id]))
      rescue ActiveRecord::RecordNotFound => e
      end
    end

    error 404 unless instance_variable_get(:"@#{model}")
  end
end

# Show docs.
get '/' do
  redirect '/docs'
end

# Send an email.
post '/contact' do
  Pony.mail to: request.params.with_indifferent_access[:to],
            from: request.params.with_indifferent_access[:from],
            subject: request.params.with_indifferent_access[:subject],
            body: request.params.with_indifferent_access[:body],
            via: :smtp,
            via_options: {
              address: ENV['SMTP_ADDRESS'],
              port: ENV['SMTP_PORT'],
              domain: ENV['SMTP_DOMAIN'],
              user_name: ENV['SMTP_USER'],
              password: ENV['SMTP_PASSWORD'],
              authentication: :plain
            }
end

# Get all events.
get '/events' do
  @events = Event.all
  rabl :'events/index', format: 'json'
end

# Get an event.
#
# @param <id> the id of the event you search for
get '/events/:id' do
  rabl :'events/show', format: 'json'
end

# Add an event.
post '/events', check: :valid_token? do
  @event = Event.new permit(request.params, Event)

  if @event.save
    rabl :'events/show', format: 'json'
  else
    status 400
    { message: @event.errors.full_messages }.to_json
  end
end

# Update an event.
#
# @param <id> the id of the event to update
put '/events/:id', check: :valid_token? do
  if @event.update permit(request.params, Event)
    rabl :'events/show', format: 'json'
  else
    status 400
    { message: @event.errors.full_messages }.to_json
  end
end

# Delete an event.
#
# @param <id> the id of the event to delete
delete '/events/:id', check: :valid_token? do
  @event.destroy
end


# Get all images.
get '/images' do
  @images = Image.all
  rabl :'images/index', format: 'json'
end

# Get an image.
#
# @param <id> the id of the image you search for
get '/images/:id' do
  rabl :'images/show', format: 'json'
end

# Add an image.
post '/images', check: :valid_token? do
  @image = Image.new permit(request.params, Image)

  if @image.save
    rabl :'images/show', format: 'json'
  else
    status 400
    { message: @image.errors.full_messages }.to_json
  end
end

# Update an image.
#
# @param <id> the id of the image to update
put '/images/:id', check: :valid_token? do
  if @image.update permit(request.params, Image)
    rabl :'images/show', format: 'json'
  else
    status 400
    { message: @image.errors.full_messages }.to_json
  end
end

# Delete an image.
#
# @param <id> the id of the image to delete
delete '/images/:id', check: :valid_token? do
  @image.destroy
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
post '/newspapers', check: :valid_token? do
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
put '/newspapers/:id', check: :valid_token? do
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
delete '/newspapers/:id', check: :valid_token? do
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
post '/organizations', check: :valid_token? do
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
put '/organizations/:id', check: :valid_token? do
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
delete '/organizations/:id', check: :valid_token? do
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
post '/pages', check: :valid_token? do
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
put '/pages/:id', check: :valid_token? do
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
delete '/pages/:id', check: :valid_token? do
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
post '/partners', check: :valid_token? do
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
put '/partners/:id', check: :valid_token? do
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
delete '/partners/:id', check: :valid_token? do
  @partner.destroy
end


# Get all sectors.
get '/sectors' do
  @sectors = Organization.all.map(&:sector)
  @sectors.uniq.to_json
end


# Ask a token.
post '/token' do
  @user = User.where( email: request.params.with_indifferent_access[:email],
                      password: Digest::MD5.hexdigest(request.params.with_indifferent_access[:password])).first

  if @user
    @user.set_token

    if @user.save
      rabl :'users/show', format: 'json'
    else
      error 404
    end
  else
    error 404
  end
end


# Get an user.
#
# @param <id> the id of the user you search for
get '/users/:id' do
  rabl :'users/show', format: 'json'
end

# Add an user.
post '/users', check: :valid_token? do
  @user = User.new permit(request.params, User)

  if @user.password
    @user.password = Digest::MD5.hexdigest @user.password
  end

  if @user.save
    rabl :'users/show', format: 'json'
  else
    status 400
    { message: @user.errors.full_messages }.to_json
  end
end

# Update an user.
#
# @param <id> the id of the user to update
put '/users/:id', check: :valid_token? do
  if @user.update permit(request.params, User)
    rabl :'users/show', format: 'json'
  else
    status 400
    { message: @user.errors.full_messages }.to_json
  end
end

# Delete an user.
#
# @param <id> the id of the user to delete
delete '/users/:id', check: :valid_token? do
  @user.destroy
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
post '/works', check: :valid_token? do
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
put '/works/:id', check: :valid_token? do
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
delete '/works/:id', check: :valid_token? do
  @work.destroy
end

not_found do
  { message: 'Not found' }.to_json
end
