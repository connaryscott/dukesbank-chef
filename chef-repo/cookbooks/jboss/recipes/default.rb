jbossJavaHome = node[:global][:javaHome]
jbossJavaOpts = node[:jboss][:javaOpts]
jbossInstallRoot = node[:jboss][:installRoot]
jbossServerConfig = node[:jboss][:serverConfig]
jbossPkgRepoUrl = "#{node[:global][:pkgRepo][:url]}/#{node[:jboss][:pkgRepoLocation]}"
jbossUser = node[:jboss][:user]
jbossGroup = node[:jboss][:group]
jbossTimezone =  node[:jboss][:timezone]
jbossPortConfig =  node[:jboss][:server][:mbean][:ServerName]

install "jboss" do
  installRoot jbossInstallRoot 
  pkgRepoUrl jbossPkgRepoUrl
  user jbossUser
  group jbossGroup
end





template "#{jbossInstallRoot}/server/#{jbossServerConfig}/conf/jboss-service.xml" do
  source "jboss-4.0.5.GA/server/default/conf/jboss-service.xml.erb"
  mode 0644
  owner "#{jbossUser}"
  group "#{jbossGroup}"
  variables({
    :jbossPortConfig => jbossPortConfig
  })
end

template "#{jbossInstallRoot}/server/#{jbossServerConfig}/conf/bindings.xml" do
  source "jboss-4.0.5.GA/server/default/conf/bindings.xml.erb"
  mode 0644
  owner "#{jbossUser}"
  group "#{jbossGroup}"
end

template "#{jbossInstallRoot}/server/#{jbossServerConfig}/conf/run.conf" do
  source "jboss-4.0.5.GA/server/default/conf/run.conf.erb"
  mode 0644
  owner "#{jbossUser}"
  group "#{jbossGroup}"
  variables({
    :jbossHome => jbossInstallRoot,
    :jbossJavaHome => jbossJavaHome,
    :jbossJavaOpts => jbossJavaOpts,
    :jbossUser => jbossUser,
    :jbossTimezone => jbossTimezone
  })
end

template "#{jbossInstallRoot}/bin/jboss.shim.sh" do
   source "jboss-4.0.5.GA/bin/jboss.shim.sh.erb"
   mode 0755
   owner "#{jbossUser}"
   group "#{jbossGroup}"
end

#start "jboss" do
  #installRoot jbossInstallRoot 
  #serverConfig jbossServerConfig
  #user jbossUser
  #group jbossGroup
#end

