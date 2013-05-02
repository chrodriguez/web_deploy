def web_deploy_home(data)
  data[home] || "#{node[:web_deploy][:application][:base]}/#{data['name']}"
end

def web_deploy_gecos(data)
  data['description']
end

def admin_users
  admins = [] 
  bag = node['user']['data_bag_name']
  user_array = node 
  node['user']['user_array_node_attr'].split("/").each do |hash_key|
    user_array = user_array.send(:[], hash_key)
  end
  Array(user_array).each do |i|
    u = data_bag_item(bag, i.gsub(/[.]/, '-'))
    admins << u
  end  
  admins
end

def web_deploy_keys(data)
  admin_users.map { |x| x['ssh_keys']}.flatten + Array(data['deploy_keys'])
end

def web_deploy_action(data)
  data['action'] || :create
end

def web_deploy_db_name(data)
  data['name']
end

def web_deploy_db_clients(db_data, database_defaults)
  db_data['clients'] || database_defaults && database_defaults['clients']
end

def web_deploy_db_username(db_data, application_data)
  db_data['username'] || application_data['name']
end

def web_deploy_db_password(db_data)
  db_data['password']
end

def web_deploy_db_server_data_bag_name(db_data, database_defaults)
  db_data['db_server_data_bag_name'] || database_defaults && database_defaults['db_server_data_bag_name']
end

def web_deploy_db_server_data_bag_item(db_data, database_defaults)
  db_data['db_server_data_bag_item'] || database_defaults && database_defaults['db_server_data_bag_item']
end

def web_deploy_db_action(db_data, application_data)
  db_data['action'] || web_deploy_action(application_data)
end

