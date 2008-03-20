{ntp, modprobe, glibc, writeText, servers}:

let

  stateDir = "/var/lib/ntp";

  ntpUser = "ntp";

  config = writeText "ntp.conf" ''
    driftfile ${stateDir}/ntp.drift

    ${toString (map (server: "server " + server + "\n") servers)}
  '';

  ntpFlags = "-c ${config} -u ${ntpUser}:nogroup -i ${stateDir}";

in

{
  name = "ntpd";
  
  users = [
    { name = ntpUser;
      uid = (import ../system/ids.nix).uids.ntp;
      description = "NTP daemon user";
      home = stateDir;
    }
  ];
  
  job = ''
    description "NTP daemon"

    start on ip-up
    stop on ip-down
    stop on shutdown

    start script

        mkdir -m 0755 -p ${stateDir}
        chown ${ntpUser} ${stateDir}

        # Needed to run ntpd as an unprivileged user.
        ${modprobe}/sbin/modprobe capability || true

        ${ntp}/bin/ntpd -q -g ${ntpFlags}

    end script

    respawn ${ntp}/bin/ntpd -n ${ntpFlags}
  '';
  
}
