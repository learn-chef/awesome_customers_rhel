#
# Cookbook Name:: awesome_customers_rhel
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# Copy commonly-used node attribute values into variables.
root_password = node['awesome_customers_rhel']['database']['root_password']
admin_password = node['awesome_customers_rhel']['database']['admin_password']
dbname = node['awesome_customers_rhel']['database']['dbname']
host = node['awesome_customers_rhel']['database']['host']
root_username = node['awesome_customers_rhel']['database']['root_username']
admin_username = node['awesome_customers_rhel']['database']['admin_username']
connection_info = { host: host, username: root_username, password: root_password }

# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password root_password
  action [:create, :start]
end

# Install the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
  action :install
end

# Create the database instance.
mysql_database dbname do
  connection(connection_info)
  action :create
end

# Add a database user.
mysql_database_user admin_username do
  connection(connection_info)
  password admin_password
  database_name dbname
  host host
  action [:create, :grant]
end

# Create a path to the SQL file in the Chef cache.
create_tables_script_path = File.join(Chef::Config[:file_cache_path], 'create-tables.sql')

# Write schema seed file to filesystem.
cookbook_file create_tables_script_path do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Seed the database with a table and test data.
execute "initialize #{dbname} database" do
  command "mysql -h #{host} -u #{admin_username} -p#{admin_password} -D #{dbname} < #{create_tables_script_path}"
  not_if  "mysql -h #{host} -u #{admin_username} -p#{admin_password} -D #{dbname} -e 'describe customers;'"
end
