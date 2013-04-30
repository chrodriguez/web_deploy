#
# Cookbook Name:: web_deploy
# Recipe:: default
#
# Copyright (C) 2013 CeSPI - UNLP
# 
# All rights reserved - Do Not Redistribute
#

def is_valid_username?(arg)
  true
end

base_dir = node.web_deploy.application.base 
directory base_dir do
  mode "0755"
  owner "root"
end

node.web_deploy.application.instances.each do | name, data |
  username = data['username'] || name 
  is_valid_username? username
  user_account username do
    comment data['gecos'] || "Aplicacion #{name}"
    create_group true
    home "#{base_dir}/#{username}"
    ssh_keys Array(node.base.administration.user.ssh_keys) + Array(data['ssh_keys'])
  end

  directory "#{base_dir}/#{username}" do
    mode "0700"
  end

end


