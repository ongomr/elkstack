#
# Cookbook:: elkstack
# Recipe:: kibana
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Creating elasticsearch User
user "#{node['kibana']['user']}" do
  comment "#{node['kibana']['user']} user"
#  uid '1000'
#  gid '1000'
  home "/home/#{node['kibana']['user']}"
  shell '/bin/bash'
#  password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
end

# Creating Kibana Root Directory for elkstack
directory "#{node['kibana']['root_dir']}" do
  owner "#{node['kibana']['user']}"
  group "#{node['kibana']['group']}"
  mode '0755'
  action :create
end

# docker run -it -d --net elk --name kibana -e ELASTICSEARCH_URL=http://elasticsearch:9200 -p 5601:5601 kibana:5.2.0
# Brings down docker kibana image
docker_image "kibana" do
  repo 'docker.elastic.co/kibana/kibana'
  tag '5.6.1'
  action :pull
end

# Creates an instance 'logstash'
docker_container "#{node['kibana']['instance_name']}" do
  repo 'docker.elastic.co/kibana/kibana'
  tag '5.6.1'
  env ['ELASTICSEARCH_URL=http://elsrv:9200']
  port ['5601:5601']
  network_mode 'elk'
  # links not needed because of the use of a delicated docker network
  #links ['kbsrv:elsrv']
  action :run
end
