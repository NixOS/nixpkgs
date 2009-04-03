{stdenv, dbus, dbusServices ? []}:

let

  homeDir = "/var/run/dbus";

  # Take the standard system configuration file, except that we don't
  # want to fork (Upstart will monitor the daemon).
  configFile = stdenv.mkDerivation {
    name = "dbus-conf";
    buildCommand = "
      ensureDir $out
      ln -s ${dbus}/etc/dbus-1/system.conf $out/system.conf

      ensureDir $out/system.d
      for i in ${toString dbusServices}; do
        ln -s $i/etc/dbus-1/system.d/* $out/system.d/
      done
    ";
  };

in

{
  name = "dbus";
  
  users = [
    { name = "messagebus";
      uid = (import ../system/ids.nix).uids.messagebus;
      description = "D-Bus system message bus daemon user";
      home = homeDir;
    }
  ];
  
  extraPath = [dbus.daemon dbus.tools];
  
  job = ''
    description "D-Bus system message bus daemon"

    start on startup
    stop on shutdown

    start script

        mkdir -m 0755 -p ${homeDir}
        chown messagebus ${homeDir}

        mkdir -m 0755 -p /var/lib/dbus
        ${dbus.tools}/bin/dbus-uuidgen --ensure

        rm -f ${homeDir}/pid
        ${dbus}/bin/dbus-daemon --config-file=${configFile}/system.conf
    end script

    respawn sleep 1000000

    stop script
        pid=$(cat ${homeDir}/pid)
        if test -n "$pid"; then
            kill -9 $pid
        fi
    end script
  '';
  
}
