# README
Ruby on Rails application for Koombea.
- User model with authentication using devise
- Loads a CSV file using sidekiq, and the content is added to Contact model
- Create a table to display Contact using boostrap and pagination
## Versions
- Ruby: 2.7.4
- Rails: 6.1.7.3
- Programmed in Ubuntu 18.04LTS
- Reinstalled in Elementary OS 7 Horus to make sure it runs on other machines

# Steps to Install
```bash
rvm install "ruby-2.7.4" # install rvm to install the ruby version
gem install bundler:2.2.26
```

## In case of `Error running '__rvm_make -j2'` :(
```bash
rvm pkg install openssl
rvm install 2.7.4 --with-openssl-dir=$rvm_path/usr
```
# Setup
## Setup postgres
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo apt-get install libpq-dev
sudo systemctl start postgresql.service
```

## Setup node
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 16
sudo apt install cmdtest # install yarn

```
## Setup Koombea app
```bash
git clone git@github.com:J0SUEFDZ/koombea.git
cd koombea
bundle install #  install all gems
rails db:create:all # create koombea_development DB
rails db:migrate # migrates changes into database
```

## Setup sidekiq
```bash
sudo apt install redis-server #install redis
redis-server # start redis
```
# Execute
```bash
rails s #on one tab Terminal
bundle exec sidekiq # on another tab Terminal
```
Use file `Koombea Contacts File - Hoja 1.csv` localted in the root of this file for testing
# Test
```bash
rails db:create RAILS_ENV=test # create DB in case doesn't exists
rails db:migrate RAILS_ENV=test # run migrations on test
bundle exec rspec
```
