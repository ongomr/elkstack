#
# Cookbook:: elkstack
# Recipe:: docker
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Creating Root Docker Directory for elkstack
directory "#{node['docker']['root_dir']}" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Installs and starts docker as a service
docker_service 'default' do
  action [:create, :start]
end

# Creating a dedicated network for ELK Stack
docker_network 'elk' do
  #subnet '10.9.8.0/24'
  #gateway '10.9.8.1'
end
