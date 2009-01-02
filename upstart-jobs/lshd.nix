{lsh, xauth, lib, nssModulesPath, lshdConfig}:

with builtins;
with lib;

{
  name = "lshd";
  
  job = with lshdConfig; ''
description "GNU lshd SSH2 daemon"

start on network-interfaces/started
stop on network-interfaces/stop

env LD_LIBRARY_PATH=${nssModulesPath}

start script
    test -d /etc/lsh || mkdir -m 0755 -p /etc/lsh
    test -d /var/spool/lsh || mkdir -m 0755 -p /var/spool/lsh

    if ! test -f /var/spool/lsh/yarrow-seed-file
    then
        ${lsh}/bin/lsh-make-seed -o /var/spool/lsh/yarrow-seed-file
    fi

    if ! test -f "${hostKey}"
    then
        ${lsh}/bin/lsh-keygen --server | \
        ${lsh}/bin/lsh-writekey --server -o "${hostKey}"
    fi
end script

respawn ${lsh}/sbin/lshd --daemonic \
   --password-helper="${lsh}/sbin/lsh-pam-checkpw" \
   -p ${toString portNumber} \
   ${if interfaces == [] then ""
     else (concatStrings (map (i: "--interface=\"${i}\"")
                              interfaces))} \
   -h "${hostKey}" \
   ${if !syslog then "--no-syslog" else ""} \
   ${if passwordAuthentication then "--password" else "--no-password" } \
   ${if publicKeyAuthentication then "--publickey" else "--no-publickey" } \
   ${if rootLogin then "--root-login" else "--no-root-login" } \
   ${if loginShell != null then "--login-shell=\"${loginShell}\"" else "" } \
   ${if srpKeyExchange then "--srp-keyexchange" else "--no-srp-keyexchange" } \
   ${if !tcpForwarding then "--no-tcpip-forward" else "--tcpip-forward"} \
   ${if x11Forwarding then "--x11-forward" else "--no-x11-forward" } \
   --subsystems=${concatStringsSep ","
                                   (map (pair: (head pair) + "=" +
                                               (head (tail pair)))
                                        subsystems)}
'';
  
}
