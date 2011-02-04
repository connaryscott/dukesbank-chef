#
# Cookbook Name:: ant
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

antInstallRoot = "#{node[:ant][:installRoot]}"
antPkgRepoUrl = "#{node[:global][:pkgRepo][:url]}/#{node[:ant][:pkgRepoLocation]}"

package "java-1.6.0-openjdk-devel" do
   action :install
   provider Chef::Provider::Package::Yum
end

install "ant" do
  installRoot antInstallRoot
  pkgRepoUrl antPkgRepoUrl
  user "root"
  group "root"
end
