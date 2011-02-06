define :createProjects, :projectsDir => nil, :projects => nil, :user => nil, :group => nil do

   script "createProjects" do
      interpreter "bash"
      user "#{params[:user]}"
      group "#{params[:group]}"
      code <<-EOH
         for project in #{params[:projects]}
         do
            if [ ! -e #{params[:projectsDir]}/${project} ]
            then
               rd-project -p ${project} --action create
            fi
         done
      EOH
   end
end
