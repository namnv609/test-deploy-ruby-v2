# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "test_deploy_v2"
set :repo_url, "git@github.com:namnv609/test-deploy-ruby-v2.git"
set :bundle_binstubs, nil

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/html/#{fetch(:application)}"


# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, [])
  .push("config/database.yml", "config/secrets.yml")
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, [])
  .push("log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle")

# Default value for keep_releases is 5
set :keep_releases, 5

after "deploy:publishing", "deploy:restart"

namespace :deploy do
  task :restart do
    invoke "unicorn:restart"
  end

  before :updated, :export_i18n_js do
    on roles(:app), wait: 5 do
      info "Export I18n JS"

      within release_path do
        execute :rake, "i18n:js:export"
      end
    end
  end
end
