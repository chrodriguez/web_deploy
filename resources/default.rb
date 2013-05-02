actions :create, :remove
default_action :create

attribute :username, :kind_of => String, :name_attribute => true
attribute :deploy_keys, :kind_of => [Array,String], :default => []
attribute :gecos, :kind_of => String
attribute :home, :kind_of => String
