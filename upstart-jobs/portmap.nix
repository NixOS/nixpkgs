{ makePortmap }:

let uid = (import ../system/ids.nix).uids.portmap;
    gid = (import ../system/ids.nix).gids.portmap;
in
{
  name = "portmap";
  
  users = [
    { name = "portmap";
      inherit uid;
      description = "portmap daemon user";
      home = "/var/empty";
    }
  ];

  groups = [
    { name = "portmap";
      inherit gid;
    }
  ];

  job =
    let portmap = makePortmap { daemonUID = uid; daemonGID = gid; };
    in
       ''
description "ONC RPC portmap"

start on network-interfaces/started
stop on network-interfaces/stop

respawn ${portmap}/sbin/portmap
'';
  
}
