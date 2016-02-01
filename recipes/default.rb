#
# Cookbook Name:: awesome_customers_rhel
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'selinux::permissive'
include_recipe 'awesome_customers_rhel::firewall'
include_recipe 'awesome_customers_rhel::web_user'
include_recipe 'awesome_customers_rhel::web'
include_recipe 'awesome_customers_rhel::database'
