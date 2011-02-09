#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

apacheInstallRoot = node[:apache][:installRoot]
apacheUser = node[:apache][:user]
apacheGroup = node[:apache][:group]
apacheListenPorts = node[:apache][:listenPorts]
apachePkgRoot = node[:apache][:pkgRoot]



package "httpd" do
   action :install
   provider Chef::Provider::Package::Yum
end

service "httpd" do
   service_name "httpd"
    # If restarted/reloaded too quickly httpd has a habit of failing.
    # This may happen with multiple recipes notifying apache to restart - like
    # during the initial bootstrap.
    restart_command "/sbin/service httpd restart && sleep 1"
    reload_command "/sbin/service httpd reload && sleep 1"
    action :enable
end


template "#{apacheInstallRoot}/etc/httpd/conf/httpd.conf" do
  source "httpd-2.2/etc/httpd/conf/httpd.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :apacheListenPorts => apacheListenPorts,
    :apacheUser => apacheUser,
    :apacheGroup => apacheGroup
  })
  notifies :restart, resources(:service => "httpd")
end

template "#{apacheInstallRoot}/etc/httpd/conf.d/pkgRepo.conf" do
  source "httpd-2.2/etc/httpd/conf.d/pkgRepo.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "httpd")
  variables({
    :pkgRoot => apachePkgRoot
  })
end

template "#{apacheInstallRoot}/etc/httpd/conf.d/yum.conf" do
  source "httpd-2.2/etc/httpd/conf.d/yum.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "httpd")
end

directory "#{apachePkgRoot}/dukesbank" do
   owner apacheUser
   group "rundeck"
   mode "0775"
   action :create
end

