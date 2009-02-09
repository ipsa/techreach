load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

# ========================
#    For Mongrel Apps
# ========================

namespace :deploy do
  
  task :start, :roles => :app do
    run "rm -rf /home/#{user}/public_html;ln -s #{current_path}/public /home/#{user}/public_html"
    run "cd #{current_path} && mongrel_rails start -e production -p #{mongrel_port} -d"
  end
  
  task :restart, :roles => :app do
    # Note: mongrel_rails restart wasn't working properly, but stop then start does..
    run "cd #{current_path} && mongrel_rails stop"
    run "cd #{current_path} && mongrel_rails start -e production -p #{mongrel_port} -d"
    run "cd #{current_path} && chmod 755 app config db lib public vendor script script/* public/disp*"
  end
  
end