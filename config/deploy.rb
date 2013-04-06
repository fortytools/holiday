require 'bundler/capistrano'
require "rvm/capistrano"

set :application, "holidays"

set :scm, :git
set :repository,  "git@github.com:fortytools/holiday.git"
set :branch, 'master'

role :web, '78.47.112.207', primary: true
role :app, '78.47.112.207', primary: true

set :deploy_via, :rsync_with_remote_cache

set :normalize_asset_timestamps, false

set :deploy_to, "/var/www/#{application}"
set :shared_path, "#{deploy_to}/shared"

set :rails_env, 'production'

set :user, 'fortytools'

set :use_sudo, false

set :bundle_without, [:development, :test]

set :rvm_ruby_string, "1.9.3"
set :rvm_type, :user

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

