default[:web_deploy][:application][:base] = "/opt/applications"
default[:web_deploy][:application][:instances] = {}
#cada instancia debería ser de la forma:
# Nombre de instancia => {
#  nombre de usuario => uid, #si no se especifica se asume nombre de instancia
#  ssh_keys_deploy => [], # se unen con las de soporte
#  database => {
#   name =>
#   user => 
#   password =>
#   server => #db_name a buscar
#  }
#
#}
