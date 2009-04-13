{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      ejabberd = {
        enable = mkOption {
          default = false;
          description = "Whether to enable ejabberd server";
        };
              
        spoolDir = mkOption {
          default = "/var/lib/ejabberd";
          description = "Location of the spooldir of ejabberd";
        };
        
        logsDir = mkOption {
          default = "/var/log/ejabberd";
          description = "Location of the logfile directory of ejabberd";
        };
        
        confDir = mkOption {
          default = "/var/ejabberd";
          description = "Location of the config directory of ejabberd";
        };
        
        virtualHosts = mkOption {
          default = "\"localhost\"";
          description = "Virtualhosts that ejabberd should host. Hostnames are surrounded with doublequotes and separated by commas";
        };
      };
    };
  };
in

###### implementation

let

cfg = config.services.ejabberd;

in

mkIf config.services.ejabberd.enable {

  require = [
    options
  ];


  services = {
    extraJobs = [{
      name = "ejabberd";
          
      job = ''
        description "EJabberd server"

        start on network-interface/started
        stop on network-interfaces/stop
      
        start script
              # Initialise state data
              mkdir -p ${cfg.logsDir}
              
              if ! test -d ${cfg.spoolDir}
              then
                  cp -av ${pkgs.ejabberd}/var/lib/ejabberd /var/lib
              fi
              
              mkdir -p ${cfg.confDir}
              test -f ${cfg.confDir}/ejabberd.cfg || sed -e 's|{hosts, \["localhost"\]}.|{hosts, \[${cfg.virtualHosts}\]}.|' ${pkgs.ejabberd}/etc/ejabberd/ejabberd.cfg > ${cfg.confDir}/ejabberd.cfg
        end script
        
        respawn ${pkgs.bash}/bin/sh -c 'export PATH=$PATH:${pkgs.ejabberd}/sbin; cd ~; ejabberdctl --logs ${cfg.logsDir} --spool ${cfg.spoolDir} --config ${cfg.confDir}/ejabberd.cfg start; sleep 1d'
        
        stop script
            ${pkgs.ejabberd}/sbin/ejabberdctl stop
        end script
      '';
    }];
  };
}
