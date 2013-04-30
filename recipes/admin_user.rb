user_account node.base.administration.user.username do
  comment "Los chicos de soporte"
  create_group true
  home node.base.administration.user.home
  ssh_keys node.base.administration.user.ssh_keys
end

directory node.base.administration.user.home do
  mode "0700"
end

