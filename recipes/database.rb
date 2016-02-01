#
# Cookbook Name:: awesome_customers_rhel
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
mysql2_chef_gem 'default' do
  action :install
end

# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Load the secrets file and the encrypted data bag item that holds the root password.
password_secret = Chef::EncryptedDataBagItem.load_secret(node['awesome_customers_rhel']['passwords']['secret_path'])
root_password_data_bag_item = Chef::EncryptedDataBagItem.load('passwords', 'sql_server_root_password', password_secret)

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password root_password_data_bag_item['password']
  action [:create, :start]
end

# Create the database instance.
mysql_database node['awesome_customers_rhel']['database']['dbname'] do
  connection(
    :host => node['awesome_customers_rhel']['database']['host'],
    :username => node['awesome_customers_rhel']['database']['username'],
    :password => root_password_data_bag_item['password']
  )
  action :create
end

# Load the encrypted data bag item that holds the database user's password.
user_password_data_bag_item = Chef::EncryptedDataBagItem.load('passwords', 'db_admin_password', password_secret)

# Add a database user.
mysql_database_user node['awesome_customers_rhel']['database']['app']['username'] do
  connection(
    :host => node['awesome_customers_rhel']['database']['host'],
    :username => node['awesome_customers_rhel']['database']['username'],
    :password => root_password_data_bag_item['password']
  )
  password user_password_data_bag_item['password']
  database_name node['awesome_customers_rhel']['database']['dbname']
  host node['awesome_customers_rhel']['database']['host']
  action [:create, :grant]
end

# Write schema seed file to filesystem.
cookbook_file node['awesome_customers_rhel']['database']['seed_file'] do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Seed the database with a table and test data.
execute 'initialize database' do
  command "mysql -h #{node['awesome_customers_rhel']['database']['host']} -u #{node['awesome_customers_rhel']['database']['app']['username']} -p#{user_password_data_bag_item['password']} -D #{node['awesome_customers_rhel']['database']['dbname']} < #{node['awesome_customers_rhel']['database']['seed_file']}"
  not_if  "mysql -h #{node['awesome_customers_rhel']['database']['host']} -u #{node['awesome_customers_rhel']['database']['app']['username']} -p#{user_password_data_bag_item['password']} -D #{node['awesome_customers_rhel']['database']['dbname']} -e 'describe customers;'"
end
