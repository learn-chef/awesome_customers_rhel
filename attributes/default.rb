default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true
default['awesome_customers_rhel']['open_ports'] = 80

default['awesome_customers_rhel']['user'] = 'web_admin'
default['awesome_customers_rhel']['group'] = 'web_admin'
default['awesome_customers_rhel']['document_root'] = '/var/www/customers/public_html'

default['awesome_customers_rhel']['secret_file'] = '/etc/chef/encrypted_data_bag_secret'

default['awesome_customers_rhel']['database']['dbname'] = 'my_company'
default['awesome_customers_rhel']['database']['host'] = '127.0.0.1'
default['awesome_customers_rhel']['database']['root_username'] = 'root'
default['awesome_customers_rhel']['database']['admin_username'] = 'db_admin'
default['awesome_customers_rhel']['database']['create_tables_script'] ='/tmp/create-tables.sql'
