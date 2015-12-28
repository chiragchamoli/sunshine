# -*- mode: ruby -*-
# vi: set ft=ruby :
# Require YAML module
require 'yaml'

params = YAML::load_file("./config.yml")


Vagrant.configure(2) do |config|
  
  server_ip             = params['ip']
  srcFolder             = params['folders_local']
  destFolder            = params['folders_vm']
  server_cpus           = "1"   # Cores
  server_memory         = "1024" # MB
  server_swap           = "1025" # Options: false | int (MB) - Guideline: Between one or two times the server_memory
  server_timezone       = "UTC"
  hostname              = params['hostname']
  # php
  php_timezone          = "UTC"    # http://php.net/manual/en/timezones.php
  php_version           = "5.6"    # Options: 5.5 | 5.6
  hhvm                  = "false"
  # pgsql
  pgsql_root_password   = "H6@qp9qm"   # We'll assume user "root"
  # mongo
  mongo_version         = "2.6"    # Options: 2.6 | 3.0
  mongo_enable_remote   = "false"  # remote access enabled when true
  github_pat            = ""
  github_url = "https://raw.githubusercontent.com/chiragchamoli/sunshine/master"
  public_folder         = destFolder
  #{}"/vagrant"
  
  config.vm.box = "ubuntu/trusty64"

  #config.vm.box_url = "https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box"
  config.vm.box_check_update = false
  config.vm.network "private_network", ip: server_ip

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.hostname = hostname

   config.vm.synced_folder srcFolder, destFolder, id: "vagrant-root",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=777,fmode=777"]

    # remove: sudo chown vagrant:www-data 
    

   # If using VirtualBox
  config.vm.provider :virtualbox do |vb|
    vb.name = hostname
    vb.customize ["modifyvm", :id, "--cpus", server_cpus]
    vb.customize ["modifyvm", :id, "--memory", server_memory]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

  # custom variables 
  
  #provision : basic 
  echo ">>> Installing 1/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/timezone.sh", args: [server_timezone]
  echo ">>> Installing 2/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/selfupdate.sh", args: [server_timezone,server_swap]
  echo ">>> Installing 3/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/optimizations.sh", privileged: true
  echo ">>> Installing 4/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/vim.sh"
  echo ">>> Installing 5/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/php.sh", args: [php_timezone, hhvm, php_version]
  echo ">>> Installing 6/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/nginx.sh", args: [server_ip, public_folder, hostname, github_url]
  echo ">>> Installing 7/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/pg.sh", args: pgsql_root_password
  echo ">>> Installing 8/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/mongodb.sh", args: [mongo_enable_remote, mongo_version]
  echo ">>> Installing 9/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/memcached.sh"
  echo ">>> Installing 10/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/redis.sh"

  # Javascript 
  nodejs_version        = "latest"   # By default "latest" will equal the latest stable version
  nodejs_packages       = [          # List any global NodeJS packages that you want to install
    "grunt-cli",
    "gulp",
    "bower",
    #"yo",
  ]
  echo ">>> Installing 11/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version, github_url)
  
  # PHP Options
  composer_packages     = [        # List any global Composer packages that you want to install
    #"phpunit/phpunit:4.0.*",
    #"codeception/codeception=*",
    #"phpspec/phpspec:2.0.*@dev",
    #"squizlabs/php_codesniffer:1.5.*",
  ]
  echo ">>> Installing 12/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/composer.sh", privileged: false, args: [github_pat, composer_packages.join(" ")]
  echo ">>> Installing 13/13"
  config.vm.provision "shell", path: "./vagrantbox/provisioning/ansible.sh"
  echo ">>> Installing completed Just Claeaning Up. "
  config.vm.provision "shell", path: "./vagrantbox/provisioning/check.sh"




end
