# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  
  server_ip             = "192.168.9.108"
  server_cpus           = "1"   # Cores
  server_memory         = "1024" # MB
  server_swap           = "1025" # Options: false | int (MB) - Guideline: Between one or two times the server_memory
  server_timezone       = "UTC"
  hostname              = "sedev2"
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
  public_folder         = "/vagrant"
  config.vm.box = "ubuntu/trusty64"

  #config.vm.box_url = "https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box"
  config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.9.108"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.hostname = hostname

   config.vm.synced_folder "code","/var/www/html", id: "vagrant-root",
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
  config.vm.provision "shell", path: "provisioning/timezone.sh", args: [server_timezone]
  config.vm.provision "shell", path: "provisioning/selfupdate.sh", args: [server_timezone,server_swap]
  config.vm.provision "shell", path: "provisioning/optimizations.sh", privileged: true
  config.vm.provision "shell", path: "provisioning/vim.sh"
  config.vm.provision "shell", path: "provisioning/php.sh", args: [php_timezone, hhvm, php_version]
  config.vm.provision "shell", path: "provisioning/nginx.sh", args: [server_ip, public_folder, hostname, github_url]
  config.vm.provision "shell", path: "provisioning/pg.sh", args: pgsql_root_password
  config.vm.provision "shell", path: "provisioning/mongodb.sh", args: [mongo_enable_remote, mongo_version]
  config.vm.provision "shell", path: "provisioning/memcached.sh"
  config.vm.provision "shell", path: "provisioning/redis.sh"

  # Javascript 
  nodejs_version        = "latest"   # By default "latest" will equal the latest stable version
  nodejs_packages       = [          # List any global NodeJS packages that you want to install
    "grunt-cli",
    "gulp",
    "bower",
    #"yo",
  ]

  config.vm.provision "shell", path: "provisioning/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version, github_url)
  
  # PHP Options
  composer_packages     = [        # List any global Composer packages that you want to install
    #"phpunit/phpunit:4.0.*",
    #"codeception/codeception=*",
    #"phpspec/phpspec:2.0.*@dev",
    #"squizlabs/php_codesniffer:1.5.*",
  ]
  config.vm.provision "shell", path: "provisioning/composer.sh", privileged: false, args: [github_pat, composer_packages.join(" ")]
  config.vm.provision "shell", path: "provisioning/ansible.sh"
  config.vm.provision "shell", path: "provisioning/check.sh"




end
