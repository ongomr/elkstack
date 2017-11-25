#
# Cookbook:: elkstack
# Recipe:: elastic
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Creating elasticsearch User
user "#{node['elasticsearch']['user']}" do
  comment "#{node['elasticsearch']['user']} user"
#  uid '1000'
#  gid '1000'
  home "/home/#{node['elasticsearch']['user']}"
  shell '/bin/bash'
#  password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
end

# Creating ElasticSearch Root Directory for elkstack
directory "#{node['elasticsearch']['root_dir']}" do
  owner "#{node['elasticsearch']['user']}"
  group "#{node['elasticsearch']['group']}"
  mode '0755'
  action :create
end

# Creating elasticsearch Data Directory
directory "#{node['elasticsearch']['data']}" do
  owner "#{node['elasticsearch']['user']}"
  group "#{node['elasticsearch']['group']}"
  mode '0755'
  action :create
end

#docker run -it -d --net elk --name elasticsearch -p 9200:9200 -p 9300:9300 elasticsearch:5.2.0
#docker pull docker.elastic.co/elasticsearch/elasticsearch:5.6.1
# Brings down docker elasticsearch image
docker_image "elasticsearch" do
  repo 'docker.elastic.co/elasticsearch/elasticsearch'
  tag '5.6.1'
  action :pull
end

# Creates an instance 'elsrv'
# Requires min 2GB's of memory for JAVA to run, by default
docker_container "#{node['elasticsearch']['instance_name']}" do
  repo 'docker.elastic.co/elasticsearch/elasticsearch'
  tag '5.6.1'
  env ['discovery.type=single-node','ES_JAVA_OPTS=-Xms512m -Xmx512m']
  port ['9200:9200','9300:9300']
# Using a named mount instead of a data volume on the vm
# Revisit and totally understand
  volumes ["esdata1:/usr/share/elasticsearch/data"]
#  volumes ["#{node['elasticsearch']['data']}:/usr/share/elasticsearch/data"]
  network_mode 'elk'
  action :run
end
