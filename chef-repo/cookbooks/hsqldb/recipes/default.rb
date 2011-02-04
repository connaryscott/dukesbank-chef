#
# Cookbook Name:: hsqldb
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

hsqldbUser = node[:hsqldb][:user]
hsqldbGroup = node[:hsqldb][:group]
hsqldbInstallRoot = node[:hsqldb][:installRoot]
hsqldbPkgRepoUrl = "#{node[:global][:pkgRepo][:url]}/#{node[:hsqldb][:pkgRepoLocation]}"
hsqldbJavaHome = "#{node[:global][:javaHome]}"

rdbInstanceName = node[:rdb][:instanceName]
rdbPort = node[:rdb][:port]
rdbUsername = node[:rdb][:username]
rdbHostname = node[:rdb][:hostname]


install "hsqldb" do
  installRoot hsqldbInstallRoot
  pkgRepoUrl hsqldbPkgRepoUrl
  user hsqldbUser
  group hsqldbGroup
end



template "#{hsqldbInstallRoot}/server.properties" do
  source "server.properties.erb"
  mode 0644
  owner "#{hsqldbUser}"
  group "#{hsqldbGroup}"
  variables({
    :rdbInstanceName => rdbInstanceName,
    :rdbPort => rdbPort
  })
end

template "#{hsqldbInstallRoot}/sqltool.rc" do
   source "sqltool.rc.erb"
  mode 0644
  owner "#{hsqldbUser}"
  group "#{hsqldbGroup}"
  variables({
    :rdbInstanceName => rdbInstanceName,
    :rdbPort => rdbPort,
    :rdbHostname => rdbHostname,
    :rdbUsername => rdbUsername
  })
end

#start "hsqldb" do
  #installRoot hsqldbInstallRoot
  #javaHome hsqldbJavaHome
  #user hsqldbUser
  #group hsqldbGroup
#end
