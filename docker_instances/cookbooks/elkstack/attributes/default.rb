#
# Cookbook:: elkstack
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Docker Attributes
default['docker']['package_version'] = "17.06.0~ce-0~ubuntu"
default['docker']['package_name'] = "docker-ce"
default['docker']['root_dir'] = '/elkstack'

# Logstash Configuration Attributes
default['logstash']['instance_name'] = 'lgsrv'
default['logstash']['user'] = "logstash"
default['logstash']['group'] = "logstash"
default['logstash']['root_dir'] = '/elkstack/logstash'
default['logstash']['pipeline']['dir'] = "#{node['logstash']['root_dir']}/pipeline"
default['logstash']['pipeline']['conf'] = "logstash.conf"
default['logstash']['conf']['dir'] = "#{node['logstash']['root_dir']}/conf"
default['logstash']['conf']['file'] = "logstash.yml"
default['logstash']['conf']['jvm'] = "jvm.options"
default['logstash']['conf']['log4j2'] = "log4j2.properties"
default['logstash']['conf']['startup'] = "startup.options"
default['logstash']['conf']['username'] = "logstash_system"
default['logstash']['conf']['password'] = "changeme"

# ElasticSearch Configuration Attributes
default['elasticsearch']['instance_name'] = 'elsrv'
default['elasticsearch']['user'] = "elasticsearch"
default['elasticsearch']['group'] = "elasticsearch"
default['elasticsearch']['data'] = "/elkstack/elasticsearch/data"
default['elasticsearch']['root_dir'] = '/elkstack/elasticsearch'

# Kibana Configuration Attributes
default['kibana']['instance_name'] = 'kbsrv'
default['kibana']['user'] = "kibana"
default['kibana']['group'] = "kibana"
default['kibana']['root_dir'] = '/elkstack/kibana'
