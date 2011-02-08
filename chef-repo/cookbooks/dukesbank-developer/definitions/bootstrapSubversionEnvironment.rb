define :bootstrapSubversionEnvironment do

   developerWorkspace = "#{node[:dukesbankDeveloper][:workspace]}"

   demoPkgsScmModule = "#{node[:dukesbankDemoPkgs][:scmModule]}"
   demoPkgsScmUrl = "#{node[:svnserver][:url]}/#{demoPkgsScmModule}"
   demoPkgsSourceUrl = node[:dukesbankDemoPkgs][:sourceUrl]
   svnServerUser = node[:svnserver][:user]
   svnServerGroup = node[:svnserver][:group]

   script "svnImportPristine" do
      not_if "svn list #{demoPkgsScmUrl}"
      interpreter "bash"
      user "#{svnServerUser}"
      group "#{svnServerGroup}"
      code <<-EOH
         umask 002 &&
         echo "i am going to download #{demoPkgsSourceUrl}" &&
         tmpZip=$(mktemp) &&
         tmpDir=$(mktemp -d) &&
         curl -L -f -k -o ${tmpZip}  "#{demoPkgsSourceUrl}" &&
         unzip -d ${tmpDir} ${tmpZip} &&
         rm -f ${tmpZip} &&
         cd ${tmpDir} &&
         echo "running: svn import  --config-dir /tmp/NOT_A_PATH -m 'bootstrap demo commit' "#{demoPkgsScmModule}" \"#{demoPkgsScmUrl}\""  &&
         svn import  --no-auth-cache --non-interactive --config-dir /tmp/NOT_A_PATH -m 'bootstrap demo commit' "#{demoPkgsScmModule}" "#{demoPkgsScmUrl}" &&
         rm -rf ${tmpDir}
      EOH
   end


   script "svnCheckoutPristine" do
      interpreter "bash"
      user "#{svnServerUser}"
      group "#{svnServerGroup}"
      code <<-EOH
         mkdir -p "#{developerWorkspace}" &&
         cd "#{developerWorkspace}" &&
         svn checkout --no-auth-cache --non-interactive --config-dir /tmp/NOT_A_PATH  "#{demoPkgsScmUrl}"
      EOH
      not_if do
         File.exists?("#{developerWorkspace}/#{demoPkgsScmModule}")
      end
   end

   script "unzipJ2eeTutorial" do
      interpreter "bash"
      user "#{svnServerUser}"
      group "#{svnServerGroup}"
      code <<-EOH
         cd "#{developerWorkspace}/#{demoPkgsScmModule}" &&
         unzip j2eetutorial14.zip
      EOH
      not_if do
         File.exists?("#{developerWorkspace}/#{demoPkgsScmModule}/j2eetutorial14")
      end
   end

   script "importJ2eeTutorial" do
      interpreter "bash"
      user "#{svnServerUser}"
      group "#{svnServerGroup}"
      code <<-EOH
         cd "#{developerWorkspace}/#{demoPkgsScmModule}" &&
         svn import  --no-auth-cache --non-interactive --config-dir /tmp/NOT_A_PATH -m 'bootstrap demo commit' j2eetutorial14 "#{demoPkgsScmUrl}/j2eetutorial14"  &&
         rm -rf j2eetutorial14 &&
         svn checkout  --no-auth-cache --non-interactive --config-dir /tmp/NOT_A_PATH "#{demoPkgsScmUrl}/j2eetutorial14"
      EOH
      not_if "svn list #{demoPkgsScmUrl}/j2eetutorial14"
   end


end
