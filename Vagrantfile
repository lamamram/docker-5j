## Toute commande doit-ere exécution dans le répertoire contenant le Vagrantfile
# vagrant up
# vagrant halt
# vagrant destroy
# vagrant global-config
#----------------------
# vagrant ssh [NAME|ID]
# access-token: myusine xYph6TpAt1yJ1hJiS3QN
Vagrant.configure(2) do |config|
  # interface réseau à utiliser (Win: ipconfig /all, Unix: ip a )
  interface = "Intel(R) Ethernet Connection (7) I219-LM #2"
  # gamme d'ip à utiliser
  range = "192.168.44.9"
  # masque de sous réseau
  cidr = "24"

  [
    ["worker4.lan", "1024", "1", "ubuntu/focal64", "#{range}4"],
    ["worker7.lan", "1024", "1", "ubuntu/focal64", "#{range}7"],
    ["formation.lan", "2048", "2", "ubuntu/focal64", "#{range}3"],
  ].each do |vmname,mem,cpu,os,ip|
    config.vm.define "#{vmname}" do |machine|

      machine.vm.provider "virtualbox" do |v|
        v.memory = "#{mem}"
        v.cpus = "#{cpu}"
        v.name = "#{vmname}"
        v.customize ["modifyvm", :id, "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      machine.vm.box = "#{os}"
      machine.vm.hostname = "#{vmname}"
      machine.vm.network "public_network",
        bridge: "#{interface}",
        ip: "#{ip}",
        netmask: "#{cidr}"
      machine.ssh.insert_key = false
      if vmname == "formation.lan"
        # copie la clé privée pour docker-machine / swarm
        [
            ["./insecure_private_key", "/home/vagrant/.ssh/insecure_private_key"]
        ].each do |src,dest|
          config.vm.provision "file", 
            source: "#{src}", destination: "#{dest}"
        end
        # lancer l'install de docker dès le lancement
        machine.vm.provision "shell", 
          path: "install_docker.sh"
        machine.vm.provision "shell", 
          path: "add_machines.sh",
          args: ["#{range}"]
      end
    end
  end
end
