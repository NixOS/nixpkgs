{ path, thisConfig, config, lib, pkgs, upstartHelpers } : with upstartHelpers; {
  options = {
    description = "synergy client lets you use a shared keyboard, mouse and clipboard";
    screenName = mkOption {
      default = "";
      description = " 
        use screen-name instead the hostname to identify
        ourselfs to the server.
        ";
      apply = x: "-n '${x}'";
    };
    address = mkOption {
      default = "";
      description = "server address to connect to";
    };
  };
  jobs = [ ( rec {
    name = "synergyc";

    # TODO start only when X Server has started as well
    job = "
description \"${name}\"

start on network-interfaces/started
stop on network-interfaces/stop

exec ${pkgs.synergy}/bin/synergyc -f ${configV "screenName"} ${configV "address"}
  ";
  
} ) ];
}
