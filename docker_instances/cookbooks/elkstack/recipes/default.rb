#
# Cookbook:: elkstack
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe "apt::default"
include_recipe "chef-apt-docker::default"
include_recipe "elkstack::docker"
include_recipe "elkstack::elastic"
include_recipe "elkstack::kibana"
include_recipe "elkstack::logstash"
