define :loadJobs do

  rundeckUser = node[:rundeck][:user]
  rundeckGroup = node[:rundeck][:group]
  rundeckProjectsDir = node[:rundeck][:projectsDir]
  jobsTemplateDir = node[:dukesbankDeveloper][:jobsTemplateDir]

  directory "#{rundeckProjectsDir}/dukesbank/jobs.d" do
     owner rundeckUser
     group rundeckGroup
     mode "0755"
     action :create
  end

  directory "#{rundeckProjectsDir}/dukesbank/jobs.d/options" do
     owner rundeckUser
     group rundeckGroup
     mode "0755"
     action :create
  end


  execute "loadCodePromoteJob" do
      command "rd-jobs load --file #{rundeckProjectsDir}/dukesbank/jobs.d/code-promote.xml"
      user "#{rundeckUser}"
      group "#{rundeckGroup}"
      action :nothing
  end

  

  template "#{rundeckProjectsDir}/dukesbank/jobs.d/code-promote.xml" do
     source "#{jobsTemplateDir}/code-promote.xml.erb"
     owner rundeckUser
     group rundeckGroup
     mode 0664
     notifies :run, resources(:execute => "loadCodePromoteJob"), :immediately
     variables({
        :rundeckProject => "dukesbank",
        :hudsonProject => "dukesbank",
        :hudsonServer => "localhost",
        :hudsonPort => "8080"
     })
  end

  execute "loadCodeDeployJob" do
      command "rd-jobs load --file #{rundeckProjectsDir}/dukesbank/jobs.d/code-deploy.xml"
      user "#{rundeckUser}"
      group "#{rundeckGroup}"
      action :nothing
  end

  template "#{rundeckProjectsDir}/dukesbank/jobs.d/code-deploy.xml" do
     source "#{jobsTemplateDir}/code-deploy.xml.erb"
     owner rundeckUser
     group rundeckGroup
     mode 0664
     notifies :run, resources(:execute => "loadCodeDeployJob"), :immediately
     variables({
        :rundeckProject => "dukesbank",
     })
  end

  template "#{rundeckProjectsDir}/dukesbank/jobs.d/options/code-deploy.options" do
     source "#{jobsTemplateDir}/options/code-deploy.options.erb"
     owner rundeckUser
     group rundeckGroup
     mode 0755
  end




end
