{stdenv, hal}:

{
  name = "hal";
  
  users = [
    { name = "haldaemon";
      uid = (import ../system/ids.nix).uids.haldaemon;
      description = "HAL daemon user";
    }
  ];

  groups = [
    { name = "haldaemon";
      gid = (import ../system/ids.nix).gids.haldaemon;
    }
  ];

  extraPath = [hal];
  
  job = ''
    description "HAL daemon"

    start on dbus
    stop on shutdown

    start script

        # !!! quick hack: wait until dbus has started
        sleep 3

        mkdir -m 0755 -p /var/cache/hald

    end script

    respawn ${hal}/sbin/hald --daemon=no --verbose=yes
  '';
  
}
