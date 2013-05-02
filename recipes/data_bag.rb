#{ id: app_en_mitra,
#  applications: [
#    { name: app_name,
#      home: #Si no se especifica se calcula como "node[:web_deploy][:application][:base]/username"
#      description: a,
#      deploy_keys: string o arreglo de claves
#      action: [:create | :remove]
#      database: { # false o ausente si no tiene db
#       clients: #no poner si se desea usar la IP del nodo 
#       username: si no se especifica se asume el nombre de la aplicacion
#       password: 
#       db_server_data_bag_name:
#       db_server_data_bag_item:
#       privileges: #all por defecto pero puede ser un symbolo o arreglo
#       action: #si no se especifica coincide con la de la app
#      }
#    },
#    ...
#    ]
#}

directory node[:web_deploy][:application][:base] do
  mode "0755"
  owner "root"
end

instances = data_bag_item(node[:web_deploy][:application][:data_bag_name], node[:web_deploy][:application][:data_bag_item])
Array(instances['applications']).each do |application |
  web_deploy application['name'] do
    home web_deploy_home(application)
    gecos web_deploy_gecos(application)
    deploy_keys web_deploy_keys(application)
    action web_deploy_action(application)
  end
  if application['database']
    web_deploy_db web_deploy_db_name(application) do
      clients web_deploy_db_clients(application)
      username web_deploy_db_username(application)
      password web_deploy_db_password(application)
      db_server_data_bag_name web_deploy_db_server_data_bag_name(application)
      db_server_data_bag_item web_deploy_db_server_data_bag_item(application)
      action web_deploy_db_action(application)
    end
  end
end


