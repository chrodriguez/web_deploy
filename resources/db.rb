actions :create, :remove
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :db_server_data_bag_name, :kind_of => String, :default => "database_servers"
attribute :db_server_data_bag_item, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :privileges, :kind_of => [Symbol, Array]
#Solo para Mysql: IPs desde donde se conectará al servidor para dar privilegios. Si no se setea, se asume node.ipaddress
attribute :clients, :kind_of => [String, Array]
# Se acepta postgres y mysql solamente
attribute :type, :kind_of => String
