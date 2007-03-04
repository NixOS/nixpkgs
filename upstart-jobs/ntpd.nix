{ntp, modprobe, glibc, pwdutils, writeText, servers}:

let

  stateDir = "/var/lib/ntp";

  ntpUser = "ntp";

  config = writeText "ntp.conf" "
    driftfile ${stateDir}/ntp.drift

    ${toString (map (server: "server " + server + "\n") servers)}
  ";

  ntpFlags = "-c ${config} -u ${ntpUser}:nogroup -i ${stateDir}";

in

{
  name = "ntpd";
  
  job = "
description \"NTP daemon\"

start on ip-up
stop on ip-down
stop on shutdown

start script

    if ! ${glibc}/bin/getent passwd ${ntpUser} > /dev/null; then
        ${pwdutils}/sbin/useradd -g nogroup -d ${stateDir} -s /noshell \\
            -c 'NTP daemon user' ${ntpUser}
    fi

    mkdir -m 0755 -p ${stateDir}
    chown ${ntpUser} ${stateDir}

    # Needed to run ntpd as an unprivileged user.
    ${modprobe}/sbin/modprobe capability

    ${ntp}/bin/ntpd -q -g ${ntpFlags}
    
end script

respawn ${ntp}/bin/ntpd -n ${ntpFlags}
  ";
  
}
