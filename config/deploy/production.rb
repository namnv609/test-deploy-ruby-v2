set :port, 2224
set :user, "deploy"
set :deploy_via, :remote_cache
set :conditionally_migrate, true
set :rails_env, "production"

server "127.0.0.1", user: fetch(:user), port: fetch(:port), roles: %w(web app db)
