{ gnunet, gnunetConfig, lib, writeText }:

assert gnunetConfig.enable;

{
  name = "gnunetd";

  users = [
    { name = "gnunetd";
      uid = (import ../system/ids.nix).uids.gnunetd;
      description = "GNUnet Daemon User";
      home = "/var/empty";
    }
  ];

  job =
    with gnunetConfig;
    let configFile = writeText "gnunetd.conf" ''
      [PATHS]
      GNUNETD_HOME = ${home}

      [GNUNETD]
      HOSTLISTURL = ${lib.concatStringsSep " " hostLists}
      APPLICATIONS = ${lib.concatStringsSep " " applications}
      TRANSPORTS = ${lib.concatStringsSep " " transports}

      [LOAD]
      MAXNETDOWNBPSTOTAL = ${toString load.maxNetDownBandwidth}
      MAXNETUPBPSTOTAL = ${toString load.maxNetUpBandwidth}
      HARDUPLIMIT = ${toString load.hardNetUpBandwidth}
      MAXCPULOAD = ${toString load.maxCPULoad}
      INTERFACES = ${lib.concatStringsSep " " load.interfaces}

      [FS]
      QUOTA = ${toString fileSharing.quota}
      ACTIVEMIGRATION = ${if fileSharing.activeMigration then "YES" else "NO"}

      [MODULES]
      sqstore = sqstore_sqlite
      dstore = dstore_sqlite
      topology = topology_default

      ${extraOptions}
    '';

    in ''
description "The GNUnet Daemon"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    test -d "${home}" || \
    ( mkdir -m 755 -p "${home}" && chown -R gnunetd:users "${home}")
end script

respawn ${gnunet}/bin/gnunetd                   \
  ${if debug then "--debug" else "" }           \
  --user="gnunetd"                              \
  --config="${configFile}"                      \
  --log="${logLevel}"
'';

}
