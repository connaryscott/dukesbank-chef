#
# Cookbook Name:: hudson
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

startService = node[:hudson][:startService]

script "install" do
   interpreter "bash"
   user "root"
   code <<-EOH
      curl -L -f -k -o /etc/yum.repos.d/hudson.repo  http://pkg.jenkins-ci.org/redhat/hudson.repo
      chmod 644 /etc/yum.repos.d/hudson.repo
      rpm --import http://pkg.jenkins-ci.org/redhat/hudson-labs.org.key
   EOH
   not_if do
      File.exists?("/etc/yum.repos.d/hudson.repo")
   end
end

package "hudson" do
   action :install
   version "1.395-1.1"
   provider Chef::Provider::Package::Yum
end

service "hudson" do
   case startService
   when "true"
      action :start
   end
end
