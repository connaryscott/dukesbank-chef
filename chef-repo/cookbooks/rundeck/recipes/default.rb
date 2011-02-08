#
# Cookbook Name:: rundeck
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


startService = node[:hudson][:startService]
projects = "#{node[:rundeck][:projects]}"
rundeckUser = node[:rundeck][:user] 
rundeckGroup = node[:rundeck][:group] 

bash "install-rundeck-repo" do
  not_if do
     File.exists?("/etc/yum.repos.d/rundeck.repo")
  end
  code "(rpm -Uvh http://rundeck.org/latest.rpm)"
end

template "/etc/sudoers.d/rundeck" do
  source "etc/sudoers.d/rundeck.erb"
  mode 0440
  owner "root"
  group "root"
end

package "rundeck" do
   action :install
   version "1.1.0-0.39"
   provider Chef::Provider::Package::Yum
end

service "rundeckd" do
   case startService
   when "true"
      action :start
   end
end

createProjects "rundeck" do
  projectsDir "/var/rundeck/projects"
  projects "#{projects}"
  user rundeckUser
  group rundeckGroup
end
