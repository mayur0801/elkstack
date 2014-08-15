# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: logstash
#
# Copyright 2014, Rackspace
#
include_recipe 'build-essential'
include_recipe 'chef-sugar'

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
end

# we should move the search somewhere else, or give a toggle so the all-in-one
# recipe named 'single' can share most of the logstash work.
es = search('node', "recipes:elasticsearch\\:\\:default AND chef_environment:#{node.chef_environment}").first

node.set['logstash']['instance']['default']['enable_embedded_es'] = false
node.set['logstash']['instance']['default']['elasticsearch_cluster'] = 'logstash'
node.set['logstash']['instance']['default']['elasticsearch_ip'] = best_ip_for(es)
node.set['logstash']['instance']['default']['bind_host_interface'] = best_ip_for(es)
node.set['logstash']['instance']['default']['elasticsearch_port'] = '9200'

node.set['logstash']['server']['enable_embedded_es'] = false
node.set['logstash']['instance']['server'] = 'logstash'
include_recipe 'logstash::server'
