# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "web-deploy-berkshelf"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-12.04.2-cespi-amd64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://vagrantbox.unlp.edu.ar/ubuntu-12.04.2-cespi-amd64.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "33.33.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|
   # chef.log_level = :debug
#    chef.encrypted_data_bag_secret_key_path = '../../../../chef-repo/.chef/databags_keys'
    chef.data_bags_path = "../../data_bags"
    chef.json = {
      :authorization => {
        :sudo => {
          :users => [ 'soporte' ],
          :groups => [ 'sudo' ],
          :passwordless => true
        },
      },
      :users => [ 'soporte' ],
      :web_deploy => {
        :application => {
          :instances => {
            :cespi_portal => {
#              :action => 'remove',
              :gecos => "Un usuario x..",
              :ssh_keys => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIkBbGX4uwWuiT4qFonk/0GGnDaiswoyqD/QZbrziEOQQCcpHH4EVHpr/Fd9tHQn3GDGARNDMhIYBLt4UaHelHqrVLDkbRnQlaG33VUq9H/ztwQXocfaCW4yjXMdVFQ5d4+u+252bXjG8vhQCaXdPKJXEnKOkpVxukSYys+Ig0uWir2oGf1tzEPwjODivBUbbF0M0/3CJdLVz2bkx4ABqNGRThmtCRhSpnmgNb+lDeX6ulLLRp8OIwGI2UsIdnKes8aroFB8hyHkXfnrYDqvKD59rWxkp8WG4FhtR40ePk5NmRgKcojfSDVfyOqZG2iC/JSaegBV46UbpU3yo9eu2x leandro@scarlett.local",
              :database => {
            #    name: #asume instance_name,
            #    user: #asume instance_name,
                password: 'mipass', 
                type: 'mysql',
                host: 'db1'
              }
            }
            }
          }
        }
      }
#      :mysql => {
#        :server_root_password => 'rootpass',
#        :server_debian_password => 'debpass',
#        :server_repl_password => 'replpass'
#      }
#    }

    chef.run_list = [
        "recipe[user]",
#        "recipe[user::data_bag]",
#        "recipe[sudo]",
#        "recipe[database::mysql]",
#        "recipe[database::postgresql]",
        "recipe[web_deploy::car]"
    ]
  end
end
