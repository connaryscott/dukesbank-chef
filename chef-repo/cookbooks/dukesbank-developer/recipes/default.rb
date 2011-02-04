#
# Cookbook Name:: dukesbank-developer
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "dukesbank-demo-pkgs"
include_recipe "ant"
include_recipe "jboss"
include_recipe "hsqldb"

javaHome = "#{node[:global][:javaHome]}"
antHome = "#{node[:ant][:installRoot]}"
jbossHome = "#{node[:jboss][:installRoot]}"
hsqldbHome = "#{node[:hsqldb][:installRoot]}"


template "/home/dukesbank/.bashrc" do
  source "bashrc.erb"
  mode 0644
  owner "dukesbank"
  group "dukesbank"
  variables({
    :javaHome => javaHome,
    :antHome => antHome,
    :jbossHome => jbossHome,
    :hsqldbHome => hsqldbHome
  })
end
