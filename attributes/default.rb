default['firewall']['ipv6_enabled'] = false
default['firewall']['allow_ssh'] = true
default['awesome_customers_rhel']['open_ports'] = [80, 443]

default['awesome_customers_rhel']['user'] = 'web_admin'
default['awesome_customers_rhel']['group'] = 'web_admin'

default['awesome_customers_rhel']['document_root'] = '/var/www/customers/public_html'

default['awesome_customers_rhel']['passwords']['secret_path'] = '/etc/chef/encrypted_data_bag_secret'

default['awesome_customers_rhel']['database']['dbname'] = 'products'
default['awesome_customers_rhel']['database']['host'] = '127.0.0.1'
default['awesome_customers_rhel']['database']['username'] = 'root'

default['awesome_customers_rhel']['database']['app']['username'] = 'db_admin'

default['awesome_customers_rhel']['database']['seed_file'] ='/tmp/create-tables.sql'
