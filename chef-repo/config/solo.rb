chef_repo_dir = File.expand_path(File.dirname(__FILE__) + "/..")
file_cache_path  chef_repo_dir
cookbook_path [ "#{chef_repo_dir}/cookbooks" ]
