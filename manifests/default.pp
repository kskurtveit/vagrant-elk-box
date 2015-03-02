define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly
   }
}

# Update APT Cache
class { 'yum':
  update => 'cron',
}

exec { 'yum update':
  before  => [ Class['logstash'] ],
  command => '/usr/bin/yum update -y'
}

file { '/vagrant/elasticsearch':
  ensure => 'directory',
  group  => 'vagrant',
  owner  => 'vagrant',
}

# Java is required
class { 'java': }

# Elasticsearch
class { 'elasticsearch':

  manage_repo  => true,
  repo_version => '1.4',
}

elasticsearch::instance { 'es-01':
  config => { 
  'cluster.name' => 'vagrant_elasticsearch',
  'index.number_of_replicas' => '0',
  'index.number_of_shards'   => '1',
  'network.host' => '0.0.0.0'
  },        # Configuration hash
  init_defaults => { }, # Init defaults hash
  before => Exec['start kibana']
}

elasticsearch::plugin{'royrusso/elasticsearch-HQ':
  module_dir => 'HQ',
  instances  => 'es-01'
}

# Logstash
class { 'logstash':
  autoupgrade  => true,
  ensure       => 'present',
  manage_repo  => true,
  repo_version => '1.4',
  require      => [ Class['java'], Class['elasticsearch'] ],
}

file { '/etc/logstash/conf.d/logstash':
  ensure  => '/vagrant/confs/logstash/logstash.conf',
  require => [ Class['logstash'] ],
}


# Kibana
package { 'curl':
  ensure  => 'present',
  require => [ Class['yum'] ],
}

file { '/vagrant/kibana':
  ensure => 'directory',
  group  => 'vagrant',
  owner  => 'vagrant',
}


exec { 'download_kibana':
  command => '/usr/bin/curl -L https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x64.tar.gz | /bin/tar xvz -C /vagrant/kibana',
  require => [ Package['curl'], File['/vagrant/kibana'],Class['elasticsearch'] ],
  timeout     => 2800
}

exec {'start kibana':
  command => '/bin/sleep 10 && /vagrant/kibana/kibana-4.0.0-linux-x64/bin/kibana & ',
  require => [ Exec['download_kibana']]
}
