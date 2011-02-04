define :start, :installRoot => nil, :serverConfig => nil, :user => nil, :group => nil do
   script "start" do
      interpreter "bash"
      user "#{params[:user]}"
      group "#{params[:group]}"
      cwd "#{params[:installRoot]}"
      code <<-EOH
          echo "DEBUG, running params[:installRoot]/bin/jboss.shim.sh"
          echo "DEBUG, with params: JBOSS_HOME=#{params[:installRoot]} RUN_CONF=#{params[:installRoot]}/server/#{params[:serverConfig]}/conf/run.conf OUTFILE=#{params[:installRoot]}/server/#{params[:serverConfig]}/log/console.out ERRFILE=#{params[:installRoot]}/server/#{params[:serverConfig]}/log/console.err"
          mkdir "#{params[:installRoot]}/server/#{params[:serverConfig]}/log"
          JBOSS_HOME="#{params[:installRoot]}" RUN_CONF="#{params[:installRoot]}/server/#{params[:serverConfig]}/conf/run.conf" OUTFILE="#{params[:installRoot]}/server/#{params[:serverConfig]}/log/console.out" ERRFILE="#{params[:installRoot]}/server/#{params[:serverConfig]}/log/console.err" "#{params[:installRoot]}/bin/jboss.shim.sh"
      EOH
   end
end
