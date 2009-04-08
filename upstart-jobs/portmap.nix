{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      portmap = {
        enable = mkOption {
          default = false;
          description = ''
            Whether to enable `portmap', an ONC RPC directory service
            notably used by NFS and NIS, and which can be queried
            using the rpcinfo(1) command.
          '';
        };
      };
    };
  };
in

###### implementation

let uid = (import ../system/ids.nix).uids.portmap;
    gid = (import ../system/ids.nix).gids.portmap;
in

mkIf config.services.portmap.enable {

  require = [
    options
  ];


  users = {
    extraUsers = [
      { name = "portmap";
        inherit uid;
        description = "portmap daemon user";
        home = "/var/empty";
      }
    ];

    extraGroups = [
      { name = "portmap";
        inherit gid;
      }
    ];
  };

  services = {
    extraJobs = [{ 
      name = "portmap";
      

      job =
        let portmap = pkgs.makePortmap { daemonUID = uid; daemonGID = gid; };
        in
          ''
          description "ONC RPC portmap"

          start on network-interfaces/started
          stop on network-interfaces/stop

          respawn ${portmap}/sbin/portmap
          '';
    }];
  };
}
