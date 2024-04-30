## Toute commande doit-ere exécution dans le répertoire contenant le Vagrantfile
# vagrant up
# vagrant halt
# vagrant destroy
# vagrant global-config
#----------------------
# vagrant ssh [NAME|ID]
# access-token: myusine xYph6TpAt1yJ1hJiS3QN
Vagrant.configure(2) do |config|
  # interface réseau à utiliser (ipconfig /all)
  interface = "Intel(R) Ethernet Connection (7) I219-V"
  # gamme d'ip à utiliser
  range = "192.168.1.3"
  # masque de sous réseau
  cidr = "24"

  [
    ["worker1.lan", "1024", "1", "ubuntu/focal64", "#{range}1"],
    ["worker2.lan", "1024", "1", "ubuntu/focal64", "#{range}2"],
    ["formation.lan", "2048", "2", "ubuntu/focal64", "#{range}0"],
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
      # lancer l'install de docker dès le lancement
      machine.vm.provision "shell", 
        path: "install_docker.sh"
    end
  end
end
