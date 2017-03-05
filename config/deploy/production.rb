set :port, 2222
set :user, "deploy"
set :deploy_via, :remote_cache
set :conditionally_migrate, true
set :stage, :production

server "127.0.0.1", user: fetch(:user), port: fetch(:port), roles: %w(web app db)
