{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    environment = {
      unixODBCDrivers = mkOption {
        default = [];
        example = "map (x : x.ini) (with pkgs.unixODBCDrivers; [ mysql psql psqlng ] )";
        description = ''
          specifies unix odbc drivers to be registered at /etc/odbcinst.ini. 
          Maybe you also want to add pkgs.unixODBC to the system path to get a
          command line client t connnect to odbc databases.
        '';
      };
    };
  };
in

###### implementation


# unixODBC drivers (this solution is not perfect.. Because the user has to
# ask the admin to add a driver.. but it's simple and works

mkIf (config.environment.unixODBCDrivers != []) {

  require = [
    options
  ];
  
  environment = {
    etc = [
      { source = 
          let inis = config.environment.unixODBCDrivers;
          in pkgs.writeText "odbcinst.ini" (pkgs.lib.concatStringsSep "\n" inis);
        target = "odbcinst.ini";
      }
    ];
  };
}
