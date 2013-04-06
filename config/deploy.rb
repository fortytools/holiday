set :application, "holidays"

set :scm, :git
set :repository,  "git@github.com:fortytools/holidays.git"

set :deploy_via, :rsync_with_remote_cache

require 'bundler/capistrano'
load 'deploy/assets'

set :normalize_asset_timestamps, false

set :deploy_to, '/var/www/holidays'
set :user, 'fortytools'

set :use_sudo, false

role :web, '78.47.112.207'
role :app, '78.47.112.207'
role :db, '78.47.112.207', :primary => true

set :bundle_without, [:development, :test]

after 'deploy:finalize_update', 'deploy:link'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

