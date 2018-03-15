# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  # config.ssh.username = "ubuntu"
  # config.ssh.password = "fbcd1ed4fe8c83b157dc6e0f"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.synced_folder ".", "/var/www/html"

  config.vm.provision "shell", path: "provision.sh"
end