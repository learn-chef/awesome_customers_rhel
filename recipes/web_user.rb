#
# Cookbook Name:: awesome_customers_rhel
# Recipe:: web_user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
group node['awesome_customers_rhel']['group']

user node['awesome_customers_rhel']['user'] do
  group node['awesome_customers_rhel']['group']
  system true
  shell '/bin/bash'
end
