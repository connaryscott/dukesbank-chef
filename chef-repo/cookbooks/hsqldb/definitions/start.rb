define :start, :installRoot => nil, :javaHome => nil, :user => nil, :group => nil do
   script "start" do
      interpreter "bash"
      user "#{params[:user]}"
      group "#{params[:group]}"
      cwd "#{params[:installRoot]}"
      code <<-EOH
          JAVA_HOME="#{params[:javaHome]}" HSQLDB_HOME="#{params[:installRoot]}" "#{params[:javaHome]}/bin/java" -cp lib/hsqldb.jar org.hsqldb.Server > "#{params[:installRoot]}/console.out" 2>"#{params[:installRoot]}/console.err" &
      EOH
   end
end
