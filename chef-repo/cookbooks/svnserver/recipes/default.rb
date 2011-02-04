#
# Cookbook Name:: svnserver
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

svnServerRepo = node[:svnserver][:repo]
svnServerUser = node[:svnserver][:user]
svnServerGroup = node[:svnserver][:group]

package "subversion" do
   action :install
   provider Chef::Provider::Package::Yum
end


#
# pass --config-dir /tmp/bogusdir, a phony place so that subversion does not read $HOME/.subversion
# chef does not do an equivalent to "sudo -H -u user" so that the vagrant user's HOME is read and could mess things up
#
script "svnadminCreate" do
   interpreter "bash"
   user "#{svnServerUser}"
   group "#{svnServerGroup}"
   cwd "/tmp"
   code <<-EOH 
      umask 002
      svnadmin create --config-dir /tmp/NOT_A_PATH "#{svnServerRepo}"
      svn info --config-dir /tmp/NOT_A_PATH "file://#{svnServerRepo}"
   EOH
   not_if do
      File.exists?(svnServerRepo)
   end
end
