lock '3.2.0'

set :user,          'admin'
set :application,   'blanchemaille_api'
set :repo_url,      "git@github.com:pinkpanda/#{fetch(:application)}.git"

ask :branch,        proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :deploy_to,     "/home/#{fetch(:user)}/apps/#{fetch(:application)}_#{fetch(:stage)}"

set :linked_files,  %w{config/database.yml}

set :rack_env,      fetch(:stage)
set :keep_releases, 3
set :pty,           true
