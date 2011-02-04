#
# Cookbook Name:: dukesbank-demo-pkgs
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "svnserver"

demopkgsSourceUrl = node[:demopkgs][:sourceUrl]
demoPkgsScmModule = "#{node[:demopkgs][:scmModule]}"
demoPkgsScmUrl = "#{node[:svnserver][:url]}/#{demoPkgsScmModule}"

svnServerUser = node[:svnserver][:user]
svnServerGroup = node[:svnserver][:group]

workspace = "#{node[:global][:workspace]}"
 
script "svnImportPristine" do
   not_if "svn list #{demoPkgsScmUrl}"
   interpreter "bash"
   user "#{svnServerUser}"
   group "#{svnServerGroup}"
   code <<-EOH
      umask 002 &&
      echo "i am going to download #{demopkgsSourceUrl}" &&
      tmpZip=$(mktemp) &&
      tmpDir=$(mktemp -d) &&
      curl -L -f -k -o ${tmpZip}  "#{demopkgsSourceUrl}" &&
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
      mkdir -p "#{workspace}" &&
      cd "#{workspace}" &&
      svn checkout --no-auth-cache --non-interactive --config-dir /tmp/NOT_A_PATH  "#{demoPkgsScmUrl}"
   EOH
   not_if do
      File.exists?("#{workspace}/#{demoPkgsScmModule}")
   end
end

script "unzipJ2eeTutorial" do
   interpreter "bash"
   user "#{svnServerUser}"
   group "#{svnServerGroup}"
   code <<-EOH
      cd "#{workspace}/#{demoPkgsScmModule}" &&
      unzip j2eetutorial14.zip 
   EOH
   not_if do
      File.exists?("#{workspace}/#{demoPkgsScmModule}/j2eetutorial14")
   end
end

script "importJ2eeTutorial" do
   interpreter "bash"
   user "#{svnServerUser}"
   group "#{svnServerGroup}"
   code <<-EOH
      cd "#{workspace}/#{demoPkgsScmModule}" &&
      svn import  --no-auth-cache --non-interactive --config-dir /tmp/NOT_A_PATH -m 'bootstrap demo commit' j2eetutorial14 "#{demoPkgsScmUrl}/j2eetutorial14"  &&
      rm -rf j2eetutorial14 &&
      svn checkout  --no-auth-cache --non-interactive --config-dir /tmp/NOT_A_PATH "#{demoPkgsScmUrl}/j2eetutorial14" 
   EOH
   not_if "svn list #{demoPkgsScmUrl}/j2eetutorial14"
end
