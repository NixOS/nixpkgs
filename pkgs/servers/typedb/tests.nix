{ stdenv, typedb }:

stdenv.mkDerivation {
  name = "typedb-can-start-server-and-console";
  meta.timeout = 10;
  buildCommand = ''
    mkdir "server_data"
    mkdir "server_log"
    echo "testing server"
    TYPEDB_SERVER_DATA=server_data TYPEDB_SERVER_LOGS=server_log ${typedb}/bin/typedb server --help > /dev/null
    echo "testing client"
    TYPEDB_SERVER_DATA=server_data TYPEDB_SERVER_LOGS=server_log ${typedb}/bin/typedb console --help > /dev/null
    rm -r server_data
    rm -r server_log
    # needed for Nix to register the command as successful
    touch $out
  '';
}
