#set :stages, %w(staging production)
#set :default_stage, "production"
#require File.expand_path("#{File.dirname(__FILE__)}/../vendor/gems/capistrano-ext-1.2.1/lib/capistrano/ext/multistage")
#
#
#namespace :db do
#  desc 'Dumps the production database to db/production_data.sql on the remote server'
#  task :remote_db_dump, :roles => :db, :only => { :primary => true } do
#    run "cd #{deploy_to}/#{current_dir} && " +
#      "rake RAILS_ENV=#{rails_env} db:database_dump --trace" 
#  end
#
#  desc 'Downloads db/production_data.sql from the remote production environment to your local machine'
#  task :remote_db_download, :roles => :db, :only => { :primary => true } do  
#    execute_on_servers(options) do |servers|
#      self.sessions[servers.first].sftp.connect do |tsftp|
#        tsftp.download!("#{deploy_to}/#{current_dir}/db/production_data.sql", "db/production_data.sql")
#      end
#    end
#  end
#
#  desc 'Cleans up data dump file'
#  task :remote_db_cleanup, :roles => :db, :only => { :primary => true } do
#    execute_on_servers(options) do |servers|
#      self.sessions[servers.first].sftp.connect do |tsftp|
#        tsftp.remove! "#{deploy_to}/#{current_dir}/db/production_data.sql" 
#      end
#    end
#  end 
#
#  desc 'Dumps, downloads and then cleans up the production data dump'
#  task :remote_db_runner do
#    remote_db_dump
#    remote_db_download
#    remote_db_cleanup
#  end
#end


set :application, 'techreach'
#set :domain, 'birminghamtechreach.org'
set :domain, '626bha.aquinas.hostingrails.com'
set :repository,  'git://github.com/ipsa/techreach.git'
set :scm, :git
#set :deploy_to, "/home/bhamtec/#{application}"
set :deploy_to, "/home/bhamtec/capistrano"
set :user, 'bhamtec'
set :use_sudo, false
set :group_writable, false                              # By default, Capistrano makes the release group-writable. You don't want this with HostingRails
set :mongrel_port, '4166'                               # Mongrel port that was assigned to you
# set :mongrel_nodes, "4"                               # Number of Mongrel instances for those with multiple Mongrels

ssh_options[:forward_agent] = true
set :branch, 'master'
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

# Cap won't work on windows without the next line (see http://groups.google.com/group/capistrano/browse_thread/thread/13b029f75b61c09d)
default_run_options[:pty] = true

role :app, domain
role :web, domain
role :db,  domain, :primary => true

#server '626bha.aquinas.hostingrails.com', :app, :web, :db, :primary => true