
define :generateShellEnvironment do

   javaHome = "#{node[:global][:javaHome]}"
   javaHome = "/usr"
   antHome = "#{node[:ant][:installRoot]}"
   jbossHome = "#{node[:jboss][:installRoot]}"
   hsqldbHome = "#{node[:hsqldb][:installRoot]}"
   user = "#{node[:dukesbankDeveloper][:user]}"
   group = "#{node[:dukesbankDeveloper][:group]}"

   template "/home/#{user}/.#{params[:name]}" do
     source "#{params[:name]}.erb"
     mode 0644
     owner user
     group group
     variables({
       :javaHome => javaHome,
       :antHome => antHome,
       :jbossHome => jbossHome,
       :hsqldbHome => hsqldbHome
     })
   end
end
