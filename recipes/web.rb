#
# Cookbook Name:: awesome_customers_rhel
# Recipe:: web
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
httpd_service 'customers' do
  mpm 'prefork'
  action [:create, :start]
end

# Add the site configuration.
httpd_config 'customers' do
  instance 'customers'
  source 'customers.conf.erb'
  notifies :restart, 'httpd_service[customers]'
end

# Create the document root directory.
directory node['awesome_customers_rhel']['document_root'] do
  recursive true
end

# Load the secrets file and the encrypted data bag item that holds the database password.
password_secret = Chef::EncryptedDataBagItem.load_secret(node['awesome_customers_rhel']['passwords']['secret_path'])
user_password_data_bag_item = Chef::EncryptedDataBagItem.load('passwords', 'db_admin_password', password_secret)

# Write the home page.
template "#{node['awesome_customers_rhel']['document_root']}/index.php" do
  source 'index.php.erb'
  mode '0644'
  owner node['awesome_customers_rhel']['user']
  group node['awesome_customers_rhel']['group']
  variables(
    :database_password => user_password_data_bag_item['password']
  )
end

# Install the mod_php5 Apache module.
httpd_module 'php' do
  instance 'customers'
end

package 'php-mysql' do
  notifies :restart, 'httpd_service[customers]'
end
