# capistrano-jelastic

Deploying rails apps on Jelastic server in an easy way. This gem is an integration for capistrano which incapsulates the capistrano deployment on Jelastic. The deployment flow in this gem is inspired by the official jelastic documentation for capistrano, see https://docs.jelastic.com/ssh-capistrano

## Getting Started

Add this line to your application's Gemfile:

```ruby
# Use Capistrano for deployment
group :development do
  # Capistrano gem and others also included in this gem 
  gem 'capistrano-jelastic', github: 'gerardo-navarro/capistrano-jelastic'
end
```

And then execute: `bundle install`

Create `{RAILS_ROOT}/Capfile` file and add the following lines:
```ruby
# This import will load all other necessary scripts, e.g. capistrano/rvm or capistrano/bundler
# It will also import all rake tasks within the included gems (lib/capistrano/tasks/*.rake)
require 'capistrano/jelastic'

Rake::Task[:production].invoke
```

Create `{RAILS_ROOT}/config/deploy.rb` to define general config for all deployment environments. Add the following config entries to this file:
```ruby

# Define the name of the application
set :application, 'some_cool_app_name'

# Define url to the VCS repository so that capistrano can initiate a checkout; git is autmatically set as version control system
# Note: You need to have registered the SSH public key of the jelastic nginx server to the specified source code repository. Otherwise, you’ll get a “Permission denied” error. If there is no public SSH key on the jelastic machine, you need to perform `ssh-keygen` and copy & paste `~/.ssh/id_rsa.pub` in your repository.
# 
# You can also use the HTTPS link of the following type: `set :repo_url, "https://example.net/GIT_user_name/repo_name.git"`
set :repo_url, 'https://github.com/gerardo-navarro/capistrano-jelastic'
```

Create `{RAILS_ROOT}/config/deploy/production.rb` to define config for a specific deployment environment:
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

# Feel free to include any config variable in the `config/deploy.rb` or in config/deploy/*.rb to customize your setup. This variables will override the default values defined in `lib/capistrano/tasks/deploy_on_jelastic.cap`. For available Capistrano configuration variables see the documentation page: http://capistranorb.com/documentation/getting-started/configuration/
```

Finalize the setup on the jelastic machine by:
- Adding `export RAILS_ENV=production` to `~/.bashrc`
- Adding `passenger_app_env production;` to `/etc/nginx/app_servers/nginx-passenger.conf`

Now you can do `bundle exec cap production deploy` and everything should be taken care of ;-D

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano-jelastic. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).