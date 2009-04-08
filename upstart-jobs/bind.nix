{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      bind = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable BIND domain name server.
          ";
        };
        cacheNetworks = mkOption {
          default = ["127.0.0.0/24"];
          description = "
            What networks are allowed to use us as a resolver.
          ";
        };
        blockedNetworks = mkOption {
          default = [];
          description = "
            What networks are just blocked.
          ";
        };
        zones = mkOption {
          default = [];
          description = "
            List of zones we claim authority over.
              master=false means slave server; slaves means addresses 
             who may request zone transfer.
          ";
          example = [{
            name = "example.com";
            master = false;
            file = "/var/dns/example.com";
            masters = ["192.168.0.1"];
            slaves = [];
          }];
        };
      };
    };
  };
in

###### implementation

let
  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";
  cfg = config.services.bind;
  concatMapStrings = pkgs.lib.concatMapStrings;

  namedConf = 
  (''
    acl cachenetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
    acl badnetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

    options {
      listen-on {any;};
      listen-on-v6 {any;};
      allow-query { cachenetworks; };
      blackhole { badnetworks; };
      forward first;
      forwarders { ${concatMapStrings (entry: " ${entry}; ") config.networking.nameservers} };
      directory "/var/run/named";
      pid-file "/var/run/named/named.pid";
    };

  '')
  + 
  (concatMapStrings 
    (_entry:let entry={master=true;slaves=[];masters=[];}//_entry; in
      ''
        zone "${entry.name}" {
          type ${if entry.master then "master" else "slave"};
          file "${entry.file}";
          ${ if entry.master then
             ''
               allow-transfer {
                 ${concatMapStrings (ip: ip+";\n") entry.slaves}
               };
             ''
             else
             ''
               masters {
                 ${concatMapStrings (ip: ip+";\n") entry.masters}
               };
             ''
          }
          allow-query { any; };
        };
      ''
    )
    cfg.zones
  )
  ;

  confFile = pkgs.writeText "named.conf" namedConf;

in

mkIf config.services.bind.enable {
  require = [
    options
  ];

  services = {
    extraJobs = [{
      name = "bind";
      job = ''
        description "BIND name server job"

        start script
          ${pkgs.coreutils}/bin/mkdir -p /var/run/named
        end script

        respawn ${pkgs.bind}/sbin/named -c ${confFile} -f 
      '';
    }];
  };
}
