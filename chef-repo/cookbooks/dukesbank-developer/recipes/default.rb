#
# Cookbook Name:: dukesbank-developer
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


#
# modify to use definitions
# generateEnvironment 
# prepareSvn
#

include_recipe "ant"
include_recipe "jboss"
include_recipe "hsqldb"
include_recipe "svnserver"
include_recipe "hudson"
include_recipe "dukesbank-demo-pkgs"
include_recipe "rundeck"


generateShellEnvironment "bashrc"
bootstrapSubversionEnvironment "demoPkgs"
generateAndLoadHudsonProject "dukesbank"
loadJobs "rundeckJobs"
