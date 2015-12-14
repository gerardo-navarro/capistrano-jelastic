# Loading normal stuff
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/nginx'

load File.expand_path('../tasks/deploy_on_jelastic.cap', __FILE__)

