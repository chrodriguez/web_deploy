#
# Cookbook Name:: web_deploy
# Recipe:: default
#
# Copyright (C) 2013 CeSPI - UNLP
# 
# All rights reserved - Do Not Redistribute
#

def database_admin_connection(db)
  dbs = Chef::EncryptedDataBagItem.load("secrets", "databases")
  Mash.new dbs[db]
end

def admin_users
  admins = []
  node.users.each do |u|
    admins << data_bag_item(node.user.data_bag_name,u)
  end
  admins
end

def is_valid_username?(arg)
  Chef::Log.error "Implementar la validacion del nombre de usuario para una aplicacion" 
  true
end

base_dir = node.web_deploy.application.base 
directory base_dir do
  mode "0755"
  owner "root"
end

# Recorremos las instancias de cada aplicacion a instalar o remover
node.web_deploy.application.instances.each do | name, data |
  username = data['username'] || name 
  is_valid_username? username
  ssh_keys = admin_users.map { |x| x['ssh_keys']}.flatten + Array(data['ssh_keys'])

  user_account username do
    comment data['gecos'] || "Aplicacion #{name}"
    create_group true
    home "#{base_dir}/#{username}"
    ssh_keys ssh_keys
    action data['action'] || :create
    ignore_failure true # Asi si lo intenta eliminar y no existe no falla
  end
  # Arreglamos los permisos del home
  if data['action'] != 'remove'
    directory "#{base_dir}/#{username}" do
      mode "0700"
    end
  end
  if data['database']
    provider = data['database']['type'] == 'postgres'? Chef::Provider::Database::Postgresql : Chef::Provider::Database::Mysql
    connection = database_admin_connection data['database']['host']
    db_name = data['database']['name'] || username 
    database db_name do
      connection connection
      provider provider
      action data['action'] || :create
    end

    provider = data['database']['type'] == 'postgres'? Chef::Provider::Database::PostgresqlUser : Chef::Provider::Database::MysqlUser

    database_user (data['database']['username'] || db_name) do
      connection connection
      provider provider
      database_name db_name
      host node.ipaddress
      password data['database']['password']
      privileges [:all]
      action :drop if data['action'] == 'remove'
      action :grant if data['action'].nil? || data['action'] != 'remove'
    end
  end

end


