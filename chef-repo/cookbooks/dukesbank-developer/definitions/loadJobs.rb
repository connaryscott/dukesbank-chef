define :loadJobs, :templateDir => nil, :jobs => nil, :user => nil, :group => nil do

   script "loadJobs" do
      interpreter "bash"
      user "#{params[:user]}"
      group "#{params[:group]}"
      code <<-EOH
         for job in #{params[:jobs]}
         do
            rd-jobs load --file "#{params[:templateDir]}/$job"
         done
      EOH
      not_if do
         File.exists?(params[:installRoot])
      end
   end
end
