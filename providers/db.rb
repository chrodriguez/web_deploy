def load_current_resource
  @name = new_resource.name
  @db_server = data_bag_item(new_resource.db_server_data_bag_name, new_resource.db_server_data_bag_item)
  @username = new_resource.username || @name
  @password = new_resource.password
  @privileges = new_resource.privileges
  @clients = Array(new_resource.clients)
  @clients = Array(node.ipaddress) if @clients.empty?
  @type = new_resource.type || "mysql"
  validate_fields!
end

action :create do
  db = self
  r = database @name do
    connection db.connection
    provider db.db_provider
    action :nothing
  end
  r.run_action(:create)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  db_name = @name
  db_password = @password
  db_privileges = @privileges
  @clients.each do |ip|
    r = database_user @username do
      connection db.connection
      provider db.db_user_provider
      database_name db_name
      privileges db_privileges
      host ip 
      password db_password
      action :nothing
    end
    r.run_action(:create)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
    r.run_action(:grant)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end

action :remove do
  db = self
  db_name = @name
  r = database @name do
    connection db.connection
    provider db.db_provider
    action :nothing
  end
  r.run_action(:drop)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  @clients.each do |ip|
    r = database_user @username do
      connection db.connection
      provider db.db_user_provider
      database_name db_name
      host ip
      action :nothing
    end
    r.run_action(:drop)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end


public
  # Usamos Mash porque el Hash que retorna el data_bag tiene elementos de la forma { 'host' => 'localhost'...} 
  # Esto no lo soporta el recurso database, porque espera que host sea un simbolo. Mash es una clase que permite acceder una Hash como si fuera de simbolos, objeto, etc. 
  def connection
    Mash.new(@db_server.to_hash)
  end

  def db_provider
    case @type 
      when "mysql" then Chef::Provider::Database::Mysql
      when "postgres" then Chef::Provider::Database::Postgresql
      else Chef::Application.fatal!("No se soporta el tipo de base de datos #{@type}", 1)
    end
  end

  def db_user_provider
    case @type 
      when "mysql" then Chef::Provider::Database::MysqlUser
      when "postgres" then Chef::Provider::Database::PostgresqlUser
      else Chef::Application.fatal!("No se soporta el tipo de base de datos #{@type}", 1)
    end
  end

private
  def validate_fields!
    Chef::Application.fatal!("El usuario de Mysql debe ser menor o igual a 16 bytes", 1) if @type ==  "mysql" && @username.length > 16
  end
