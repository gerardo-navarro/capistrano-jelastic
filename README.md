# capistrano-jelastic

Deploying rails apps on Jelastic server in an easy way. This gem is an integration for capistrano which incapsulates the capistrano deployment on Jelastic. The deployment flow in this gem is inspired by the official jelastic documentation for capistrano, see https://docs.jelastic.com/ssh-capistrano

## Getting Started

Add this line to your application's Gemfile:

```ruby
# Use Capistrano for deployment
gem 'capistrano-jelastic', group: :development
```

Do `bundle install`

Do `bundle exec cap install` and adjust the deployment config variables in the generated files:
- `config/deploy.rb` - general config variables for thw whole deployment
- `config/deploy/{production,staging}.rb` - specific config variables for each deployment environment

Finalize the setup on the deployment jelastic machine by:
- Register the SSH public key of the jelastic nginx server on the specified source code repository. Otherwise, you’ll get a “Permission denied” error. If there is no public SSH key on the jelastic machine, you need to perform `ssh-keygen` and copy & paste `~/.ssh/id_rsa.pub` in your repository.
-  Define the files that need to be linked in order to inject production properties from the folder `/var/www/webroot/shared/config/`, e.g. `/var/www/webroot/shared/config/database.yml` and `/var/www/webroot/shared/config/secret.yml`
- Adding `export RAILS_ENV=production` to `~/.bashrc`, `echo "export RAILS_ENV=production" >> ~/.bashrc`
- Adding `passenger_app_env production;` to `/etc/nginx/app_servers/nginx-passenger.conf`
- Restart the whole environment – just to be sure ;-D

Now you can do `bundle exec cap production deploy` and everything should be taken care of ;-D

## Generated capistrano deployment files

### `Capfile`
```ruby
# This import will load all other necessary scripts, e.g. capistrano/rvm or capistrano/bundler
# It will also import all capistrano rake tasks within the installed gems (lib/capistrano/tasks/*.rake)
require 'capistrano/jelastic'

Rake::Task[:production].invoke
```

### `config/deploy.rb`
```ruby
# Define the name of the application
set :application, 'some_cool_app_name'

# Define url to the VCS repository so that capistrano can initiate a checkout; git is autmatically set as version control system
# Note: You need to have registered the SSH public key of the jelastic nginx server to the specified source code repository. Otherwise, you’ll get a “Permission denied” error. If there is no public SSH key on the jelastic machine, you need to perform `ssh-keygen` and copy & paste `~/.ssh/id_rsa.pub` in your repository.
# 
# You can also use the HTTPS link of the following type: `set :repo_url, "https://example.net/GIT_user_name/repo_name.git"`
set :repo_url, 'https://github.com/gerardo-navarro/capistrano-jelastic'
```

### `config/deploy/{production,staging}.rb`
```ruby
# Custom Roles Config
# ==================
# Defines a role with one or multiple servers. Specify the username and a domain or IP for the server.
# The of the url is composed of {nodeid}-{uid}@gate.jelastic.{your.hoster}, where `nodeid` is the node ID value of the Apache application server container in your environment and `uid` is the number before @ symbol in your SSH connection string.
# Be aware the nodeid of the database should be different to the nodeid of the `app` and `web` role
role :app, '123456-78900@gate.jelastic.hoster.com' <-- change this
role :web, '123456-78900@gate.jelastic.hoster.com' <-- change this
role :db,  '123456-78900@gate.jelastic.hoster.com' <-- change this

# Custom Server Config
# ==================
# Defines a single server with a list of roles and multiple properties.
# See http://docs.jelastic.com/ssh-capistrano
server 'gate.jelastic.hoster.com', user: '123456-78900', roles: %w{web app} <-- change this

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
set :ssh_options, {
  port: 3022
  # keys: %w(/home/rlisowski/.ssh/id_rsa),
  # forward_agent: false,
  # auth_methods: %w(password)
}

# Configuration
# =============
# Defines the files that need to be linked in order to inject production properties from the folder `/var/www/webroot/shared/config/`
# To get this working you need to ssh-log into the system and `cd /var/www/webroot/shared/config`. Then create the production files you need, e.g. `/var/www/webroot/shared/config/database.yml` or `/var/www/webroot/shared/config/secrets.yml`
set :linked_files, fetch(:linked_files, []) | ['config/database.yml', 'config/secrets.yml']

# Feel free to include any config variable in the `config/deploy.rb` or in config/deploy/*.rb to customize your setup. This variables will override the default values defined in `lib/capistrano/tasks/capistrano_jelastic_defaults.cap`. For available Capistrano configuration variables see the documentation page: http://capistranorb.com/documentation/getting-started/configuration/
```

## Contributing

You are more than welcome to constribute to this repository.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
