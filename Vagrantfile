script_name="install-devstack"
VAGRANTFILE_API_VERSION = "2"
#####################
# networking settting
#####################
## controller node
controller_managment_ip='10.1.2.44'
controller_public_ip='192.168.56.11'


## network  node
network_managment_ip='10.1.2.45'
network_public_ip='192.168.56.12'
network_data_ip='172.168.124.45'


## compute  node
compute_managment_ip='10.1.2.46'
compute_public_ip='192.168.56.13'
compute_data_ip='172.168.124.46'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "ubuntu64_chef_puppet"
    config.vm.boot_timeout=7200
    # syncup folder setting
    config.vm.synced_folder "data", "/vagrant_data"
    ################# 
    #controller node 
    ################# 
    config.vm.define :controller do |icehouse1_config| #
	    icehouse1_config.vm.network :private_network, ip: controller_managment_ip
	    icehouse1_config.vm.network :private_network, ip: controller_public_ip
	    icehouse1_config.vm.host_name = "controller"
	    #icehouse1_config.vm.network :forwarded_port, guest: 80, host: 8079
	    #icehouse1_config.vm.network :forwarded_port, guest: 22, host: 2229

	    config.vm.provider :virtualbox do |vb|
		     vb.gui = false
		     vb.customize ["modifyvm", :id, "--memory", "2048"]
	    end

            icehouse1_config.vm.provision "shell" do |s|
		    s.path       = "scripts/install-devstack.sh"
		    s.args       = ["local.conf.controller"]
                    s.privileged = false
	    end
    end
    ################# 
    #network  node
    ################# 
    config.vm.synced_folder "data", "/vagrant_data"
    config.vm.define :network do |icehouse2_config|
            icehouse2_config.vm.network :private_network,ip: network_managment_ip
            icehouse2_config.vm.network :private_network,ip: network_data_ip
            icehouse2_config.vm.network :private_network, ip: network_public_ip
            icehouse2_config.vm.host_name = "network"

            config.vm.provider :virtualbox do |vb|
        	     vb.gui = false
        	     vb.customize ["modifyvm", :id, "--memory", "1024"]
            end
            #icehouse2_config.vm.network :forwarded_port, guest: 80, host: 8086
            #icehouse2_config.vm.network :forwarded_port, guest: 22, host: 2224

            icehouse2_config.vm.provision "shell" do |s|
		    s.path       = "scripts/install-devstack.sh"
		    s.args       = ["local.conf.network"]
                    s.privileged = false
	    end
       end 
    ################# 
    # compute  node
    ################# 
    config.vm.synced_folder "data", "/vagrant_data"
    config.vm.define :compute do |icehouse3_config|
            icehouse3_config.vm.network :private_network,ip: compute_managment_ip
            #icehouse3_config.vm.network :private_network, ip: "192.168.56.13"
            icehouse3_config.vm.network :private_network, ip: compute_data_ip
            icehouse3_config.vm.host_name = "compute"

            config.vm.provider :virtualbox do |vb|
        	     vb.gui = false
        	     vb.customize ["modifyvm", :id, "--memory", "2048"]
            end
            #icehouse3_config.vm.network :forwarded_port, guest: 80, host: 8091
            #icehouse3_config.vm.network :forwarded_port, guest: 22, host: 2226

            icehouse3_config.vm.provision "shell" do |s|
		    s.path       = "scripts/install-devstack.sh"
		    s.args       = ["local.conf.compute"]
                    s.privileged = false
	    end

       end
end
