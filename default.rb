default['firewall']['ipv6_enabled'] = false
default['firewall']['allow_ssh'] = true
default['awesome_customers_rhel']['open_ports'] = [80, 443]

default['awesome_customers_rhel']['user'] = 'web_admin'
default['awesome_customers_rhel']['group'] = 'web_admin'

default['awesome_customers_rhel']['document_root'] = '/var/www/customers/public_html'
