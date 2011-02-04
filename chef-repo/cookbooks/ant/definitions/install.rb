define :install, :installRoot => nil, :pkgRepoUrl => nil, :user => nil, :group => nil do

   script "install" do
      interpreter "bash"
      user "#{params[:user]}"
      group "#{params[:group]}"
      code <<-EOH
         pkgZip=$(mktemp) &&
         curl -k -f #{params[:pkgRepoUrl]} -o ${pkgZip} &&
         mkdir -p #{params[:installRoot]} &&
         unzip -d  #{params[:installRoot]}/.. ${pkgZip} &&
         chmod +x #{params[:installRoot]}/bin/* &&
         rm -f ${pkgZip}
      EOH
      not_if do
         File.exists?(params[:installRoot])
      end
   end
end
