# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Loading normal stuff
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# require 'capistrano/nginx'

load File.expand_path('../tasks/capistrano_jelastic_defaults.cap', __FILE__)
load File.expand_path('../tasks/deploy_on_jelastic.cap', __FILE__)
load File.expand_path('../tasks/install_capistrano_jelastic.rake', __FILE__)

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

# Rake::Task[:production].invoke?
