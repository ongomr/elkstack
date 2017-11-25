#
# Cookbook:: elkstack
# Recipe:: logstash
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Creating elasticsearch User
user "#{node['logstash']['user']}" do
  comment "#{node['logstash']['user']} user"
#  uid '1000'
#  gid '1000'
  home "/home/#{node['logstash']['user']}"
  shell '/bin/bash'
#  password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
end

# Creating Logstash Root Directory for elkstack
directory "#{node['logstash']['root_dir']}" do
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
  mode '0755'
  action :create
end

# Creating logstash Configuration Directory
directory "#{node['logstash']['pipeline']['dir']}" do
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
  mode '0755'
  action :create
end

# Creating logstash Configuration Directory
directory "#{node['logstash']['conf']['dir']}" do
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
  mode '0755'
  action :create
end

# Creating logstash Pipline Configuration file from a template
template "#{node['logstash']['pipeline']['dir']}/#{node['logstash']['pipeline']['conf']}" do
  source "logstash.conf.erb"
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
    variables({
      :instance_name      => node.default['elasticsearch']['instance_name']
 })
end

# Creating logstash Configuration file from a template
template "#{node['logstash']['conf']['dir']}/#{node['logstash']['conf']['file']}" do
  source "logstash.yml.erb"
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
    variables({
      :instance_name      => node.default['elasticsearch']['instance_name'],
      :username      => node.default['logstash']['conf']['username'],
      :password      => node.default['logstash']['conf']['password']
    })
end

# Creating logstash JVM Configuration file from a template
template "#{node['logstash']['conf']['dir']}/#{node['logstash']['conf']['jvm']}" do
  source "logstash_jvm.options.erb"
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
    variables({
 })
end

# Creating logstash Log4j2 Configuration file from a template
template "#{node['logstash']['conf']['dir']}/#{node['logstash']['conf']['log4j2']}" do
  source "logstash_log4j2.properties.erb"
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
    variables({
    })
end

# Creating logstash Startup Configuration file from a template
template "#{node['logstash']['conf']['dir']}/#{node['logstash']['conf']['startup']}" do
  source "logstash_startup.options.erb"
  owner "#{node['logstash']['user']}"
  group "#{node['logstash']['group']}"
    variables({
 })
end

#docker run -it -d --net elk --name logstash -p 9998:9998 logstash:5.2.0 \
#    -e 'input { tcp { port => "9998" codec => json } } output { elasticsearch { hosts => "elasticsearch" } }'
# Brings down docker logstash image
docker_image "logstash" do
  repo 'docker.elastic.co/logstash/logstash'
  tag '5.6.1'
  action :pull
end

# Creates an instance 'logstash'
docker_container "#{node['logstash']['instance_name']}" do
  repo 'docker.elastic.co/logstash/logstash'
  tag '5.6.1'
  env ['LS_JAVA_OPTS=-Xms512m -Xmx512m']
  port ['9998:9998']
# Using a named mount instead of a data volume on the vm
# Revisit and totally understand
#  volumes ["lsdata1:/usr/share/logstash/"]
  volumes ["#{node['logstash']['pipeline']['dir']}:/usr/share/logstash/pipeline/",
            "#{node['logstash']['conf']['dir']}:/usr/share/logstash/config/"]
  network_mode 'elk'
  # links not needed because of the use of a delicated docker network
  #links ['lgsrv:elsrv']
  action :run
end
