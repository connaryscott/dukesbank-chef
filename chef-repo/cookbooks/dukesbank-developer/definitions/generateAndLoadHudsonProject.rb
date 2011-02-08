define :generateAndLoadHudsonProject do

   dukesbankUser = node[:dukesbankDeveloper][:user]
   dukesbankGroup = node[:dukesbankDeveloper][:group]
   hudsonProjectXml = node[:dukesbankDeveloper][:hudsonProjectXml]

   hudsonHostname = node[:hudson][:hostname]
   hudsonListenPort = node[:hudson][:listenPort]
   hudsonUrl = node[:hudson][:url]
   hudsonCliJarUrl = node[:hudson][:cliJarUrl]


   demoPkgsScmModule = "#{node[:dukesbankDemoPkgs][:scmModule]}"
   demoPkgsScmUrl = "#{node[:svnserver][:url]}/#{demoPkgsScmModule}"

   javaHome = "#{node[:global][:javaHome]}"

   antHome = "#{node[:ant][:installRoot]}"

   jbossHome = "#{node[:jboss][:installRoot]}"


   #
   # only load dukesbank if directed to do so by another resource
   #
   execute "loadHudsonProject" do
      command "id; hudsonCliJar=$(mktemp) && curl -kfL -o $hudsonCliJar #{hudsonCliJarUrl} &&  java -jar ${hudsonCliJar} -s #{hudsonUrl} delete-job dukesbank; cat #{hudsonProjectXml} | java -jar ${hudsonCliJar} -s #{hudsonUrl} create-job dukesbank && rm -f $hudsonCliJar"
      returns 0
      action :nothing
      user "#{dukesbankUser}"
      group "#{dukesbankGroup}"
   end




   template "#{hudsonProjectXml}" do
      source "hudson/project-svn.xml.erb"
      mode 0644
      owner "#{dukesbankUser}"
      group "#{dukesbankGroup}"
      notifies :run, resources(:execute => "loadHudsonProject"), :immediately
   
   
      variables({
         :projectScmUrl => "#{demoPkgsScmUrl}/j2eetutorial14",
         :javaHome => javaHome,
         :antHome => antHome,
         :jbossHome => jbossHome
      })
   end
   
   script "LoadHudsonProjectIfNotExist" do
      interpreter "bash"
      user "#{dukesbankUser}"
      group "#{dukesbankGroup}"
      action :run
      notifies :run, resources(:execute => "loadHudsonProject"), :immediately
      code <<-EOH
         /bin/true
      EOH
      not_if "curl --stderr  /dev/null -o  /dev/null -skfL #{hudsonUrl}/job/dukesbank"
   end

end
