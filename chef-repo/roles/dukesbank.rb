name "dukesbank"
description "dukesbank jboss role"
run_list(
   "recipe[apache]",
   "recipe[rundeck]",
   "recipe[dukesbank-developer]"
)
#we need ant and java, try java-1.6.0-openjdk-devel which is an rpm for centos that includes compiler
default_attributes(
   "global" => {
      "javaHome" => "/usr",
      "pkgRepo" => {
         "url" => "http://localhost/pkgs"
      }
   }
)
override_attributes(
   "jboss" => {
      "installRoot" => "/home/dukesbank/jboss-4.0.5.GA",
      "user" => "dukesbank",
      "group" => "dukesbank",
      "server" => {
         "mbean" => { 
            "ServerName" => "ports-01"
         }
      }
   },
   "hsqldb" => {
      "installRoot" => "/home/dukesbank/hsqldb",
      "user" => "dukesbank",
      "group" => "dukesbank"
   },
   "svnserver" => {
      "repo" => "/home/dukesbank/svnroot",
      "user" => "dukesbank",
      "group" => "dukesbank",
      "url" => "file:///home/dukesbank/svnroot"
   }
)
