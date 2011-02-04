# configuration used to install hsqldb with:
default[:hsqldb][:pkgRepoLocation] = "/hsqldb/zips/hsqldb_1_8_0_10.zip"
default[:hsqldb][:installRoot] = "/usr/local/hsqldb"
default[:hsqldb][:user] = hsqldb
default[:hsqldb][:group] = hsqldb
default[:hsqldb][:javaHome] = "/usr"

# configuration settings with respect to the database
default[:rdb][:port] = "1701"
default[:rdb][:hostname] = "localhost"
default[:rdb][:connection] = "jdbc:hsqldb:hsql://#{default[:rdb][:hostname]}:#{default[:rdb][:port]}"
default[:rdb][:username] = "sa"
default[:rdb][:password] = ""
default[:rdb][:instanceName] = "db1"

# configuration settings with respect to the schema(s)
default[:rdb][:schema][:dataSourceName] = "DefaultDS"
default[:rdb][:schema][:minPoolSize] = "5"
default[:rdb][:schema][:maxPoolSize] = "20"
default[:rdb][:schema][:username] = "#{default[:rdb][:username]}"
default[:rdb][:schema][:password] = "#{default[:rdb][:password]}"
default[:rdb][:schema][:type] = "hsql"
