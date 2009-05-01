{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {

      autofs = {
        enable = mkOption {
          default = false;
          description = "
            automatically mount and unmount filesystems
          ";
        };

        autoMaster = mkOption {
          example = ''
            autoMaster = let
              map = pkgs.writeText "auto" '''
               kernel    -ro,soft,intr       ftp.kernel.org:/pub/linux
               boot      -fstype=ext2        :/dev/hda1
               windoze   -fstype=smbfs       ://windoze/c
               removable -fstype=ext2        :/dev/hdd
               cd        -fstype=iso9660,ro  :/dev/hdc
               floppy    -fstype=auto        :/dev/fd0
               server    -rw,hard,intr       / -ro myserver.me.org:/ \
                                             /usr myserver.me.org:/usr \
                                             /home myserver.me.org:/home
              ''';
            in '''
              /auto file:${map}
            '''
          '';
          description = "
            file contents of /etc/auto.master. See man auto.master
            see 
            man auto.master and man 5 autofs
          ";
        };

        timeout = mkOption {
          default = 600;
          description = "Set the global minimum timeout, in seconds, until directories are unmounted";
        };

        debug = mkOption {
          default = false;
          description = "pass -d to automount and write log to /var/log/autofs";
        };
      };
    };
  };

###### implementation

  inherit (pkgs) lib writeTextopenssh autofs5;

  cfg = (config.services.autofs);

  modprobe = config.system.sbin.modprobe;

in

mkIf cfg.enable {

  require = [
    options
  ];

  environment = {
    etc =
      [ {
        target = "auto.master";
        source = pkgs.writeText "auto.master" cfg.autoMaster;
      }];
  };

  services = {
    extraJobs = [
    {
      name = "autofs";

      # kernel module autofs  supports kernel protocol v3
      # kernel module autofs4 supports kernel protocol v3, v4, v5
      job = ''
        description "automatically mount filesystems"

        start on network-interfaces/started
        stop on network-interfaces/stop

        PATH=${pkgs.nfsUtils}/sbin:${modprobe}/sbin

        start script
          modprobe autofs4 || true
        end script

        script
          ${if cfg.debug then "exec &> /var/log/autofs" else ""}
          ${pkgs.autofs5}/sbin/automount -f -t ${builtins.toString cfg.timeout} ${if cfg.debug then "-d" else ""} "${pkgs.writeText "auto.master" cfg.autoMaster}"
        end script
      '';
    }
    ];
  };
}
