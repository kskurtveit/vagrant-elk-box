# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
# Install wget
yum -y install wget;
yum -y install http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-11.noarch.rpm
yum -y install puppet facter
yum -y install rubygems

mkdir -p /etc/puppet/modules;
if [ ! -d /etc/puppet/modules/file_concat ]; then
puppet module install ispavailability/file_concat
fi
if [ ! -d /etc/puppet/modules/yum ]; then
#puppet module install puppetlabs-apt
puppet module install example42-yum
fi
if [ ! -d /etc/puppet/modules/java ]; then
puppet module install puppetlabs-java
fi
if [ ! -d /etc/puppet/modules/elasticsearch ]; then
puppet module install elasticsearch-elasticsearch
fi
if [ ! -d /etc/puppet/modules/logstash ]; then
puppet module install elasticsearch-logstash
fi
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # set to false, if you do NOT want to check the correct VirtualBox Guest Additions version when booting this box
  if defined?(VagrantVbguest::Middleware)
    config.vbguest.auto_update = true
  end

  config.vm.box = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"
  config.vm.network :forwarded_port, guest: 5601, host: 5601
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 9300, host: 9300
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2", "--memory", "2048"]
  end
  config.vm.provision "shell", inline: $script
  config.vm.provision "puppet", manifests_path: "manifests", manifest_file: "default.pp"

end
