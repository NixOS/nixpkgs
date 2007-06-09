{stdenv, hal}:

let

  homeDir = "/var/run/dbus";

in

{
  name = "hal";
  
  users = [
    { name = "haldaemon";
      uid = (import ../system/ids.nix).uids.haldaemon;
      description = "HAL daemon user";
#      home = homeDir;
    }
  ];

  extraPath = [hal];
  
  job = "
description \"HAL daemon\"

start on dbus
stop on shutdown

start script

    mkdir -m 0755 -p /var/cache/hald

end script

respawn ${hal}/sbin/hald --daemon=no --verbose=yes
  ";
  
}
