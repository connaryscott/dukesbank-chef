#
# Cookbook Name:: rundeck
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "install-rundeck-repo" do
  code "(rpm -Uvh http://rundeck.org/latest.rpm)"
  not_if do
     File.exists?("/etc/yum.repos.d/rundeck.repo")
  end
end

package "rundeck" do
   action :install
   version "1.1.0-0.39"
   provider Chef::Provider::Package::Yum
end
