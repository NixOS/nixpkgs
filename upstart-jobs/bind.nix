{config, pkgs}: 
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
{
  name = "bind";
  job = ''
    description "BIND name server job"

    start script
      ${pkgs.coreutils}/bin/mkdir -p /var/run/named
    end script

    respawn ${pkgs.bind}/sbin/named -c ${confFile} -f 
  '';
} 
