#
# Cookbook Name:: awesome_customers_rhel
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'awesome_customers_rhel::database' do
  context 'When all attributes are set, on CentOS 7.2.1511' do
    before do
      stub_command("mysql -h fake_host -u fake_admin -pfake_admin_password -D fake_database -e 'describe customers;'").and_return(false)
    end

    let(:connection_info) do
      { host: 'fake_host', username: 'fake_root', password: 'fake_root_password' }
    end

    let(:create_tables_script_path) { File.join(Chef::Config[:file_cache_path], 'create-tables.sql') }

    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511') do |node|
        node.set['awesome_customers_rhel']['database']['root_password'] = 'fake_root_password'
        node.set['awesome_customers_rhel']['database']['admin_password'] = 'fake_admin_password'
        node.set['awesome_customers_rhel']['database']['dbname'] = 'fake_database'
        node.set['awesome_customers_rhel']['database']['host'] = 'fake_host'
        node.set['awesome_customers_rhel']['database']['root_username'] = 'fake_root'
        node.set['awesome_customers_rhel']['database']['admin_username'] = 'fake_admin'
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'sets the MySQL service root password' do
      expect(chef_run).to create_mysql_service('default')
        .with(initial_root_password: 'fake_root_password')
    end

    it 'creates the database instance' do
      expect(chef_run).to create_mysql_database('fake_database')
        .with(connection: connection_info)
    end

    it 'creates the database user' do
      expect(chef_run).to create_mysql_database_user('fake_admin')
        .with(connection: connection_info, password: 'fake_admin_password', database_name: 'fake_database', host: 'fake_host')
    end

    it 'seeds the database with a table and test data' do
      expect(chef_run).to run_execute('initialize fake_database database')
        .with(command: "mysql -h fake_host -u fake_admin -pfake_admin_password -D fake_database < #{create_tables_script_path}")
    end
  end
end
