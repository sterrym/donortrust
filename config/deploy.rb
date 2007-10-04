require 'mongrel_cluster/recipes'
set :application, "donortrust"
set :repository,  "svn://rubyforge.org/var/svn/#{application}/trunk"

set :deploy_to, "/home/dtrust/#{application}"
set :user, "dtrust"

set :mongrel_conf, "/etc/mongrel_cluster/#{application}.yml"
set :mongrel_clean, true

role :app, "slice.christmasfuture.org"
role :web, "slice.christmasfuture.org"
role :db,  "slice.christmasfuture.org", :primary => true

namespace :deploy do

  task :cold do
    update
    migrate
    setup_mongrel_cluster
    start
  end

  # until mongrel_cluster updates to cap2...
  task :start,    :roles => :app do start_mongrel_cluster end
  task :stop,     :roles => :app do stop_mongrel_cluster end
  task :restart,  :roles => :app do restart_mongrel_cluster end

  namespace :donortrust do
    desc <<-DESC
    donortrust cold deployment
    DESC
    task :cold do
      transaction do
        update
        migrate
        setup_mongrel_cluster
        install_backgroundrb # it's not included in the repository because of windows incompatibilities
        start
        start_backgroundrb
      end
    end

    desc <<-DESC
    donortrust-specific deployment task
    DESC
    task :default do
      transaction do
        stop_backgroundrb
        update
        install_backgroundrb # it's not included in the repository because of windows incompatibilities
        restart
        start_backgroundrb
      end
    end
  end

  task :setup_mongrel_cluster do
    sudo "cp #{release_path}/config/mongrel_cluster.yml #{mongrel_conf}"
    sudo "chown mongrel:www-data #{mongrel_conf}"
    sudo "chmod g+w #{mongrel_conf}"
  end
  
  desc <<-DESC
  Install backgrounDRB since it's incompatible with windows boxes
  DESC
  task :install_backgroundrb, :roles => :web do
    cmd = "cd #{release_path}/vendor/plugins;svn co http://svn.devjavu.com/backgroundrb/tags/release-0.2.1 backgroundrb;cd #{release_path}"
    send(run_method, cmd)
  end
  
  desc <<-DESC
  Start the Backgroundrb daemon on the app server.
  DESC
  task :start_backgroundrb , :roles => :web do
    cmd = "#{release_path}/script/backgroundrb start"
    send(run_method, cmd)
  end

  desc <<-DESC
  Restart the Backgroundrb daemon on the app server.
  DESC
  task :restart_backgroundrb , :roles => :web do
    cmd = "#{release_path}/script/backgroundrb restart"
    send(run_method, cmd)
  end

  desc <<-DESC
  Stop the Backgroundrb daemon on the app server.
  DESC
  task :stop_backgroundrb , :roles => :web do
    cmd = "#{current_path}/script/backgroundrb stop"
    send(run_method, cmd)
  end

end