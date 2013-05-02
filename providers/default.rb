def load_current_resource
  @home = new_resource.home || "/home/#{new_resource.name}"
  @username = new_resource.username
  @gecos = new_resource.gecos
  @deploy_keys = new_resource.deploy_keys
end

action :create do
  home = @home
  keys = @deploy_keys
  gecos = @gecos
  r = user_account @username do
    comment gecos
    create_group true
    home home
    ssh_keys keys
    action :nothing
  end
  r.run_action(:create)
  directory @home do
    mode "0700"
  end
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

action :remove do
  r = user_account @username do
    ignore_failure true
    action :nothing
  end
  r.run_action(:remove)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

