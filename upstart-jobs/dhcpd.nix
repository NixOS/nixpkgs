{dhcp, configFile, interfaces}:

let

  stateDir = "/var/lib/dhcp"; # Don't use /var/state/dhcp; not FHS-compliant.

in
  
{
  name = "dhcpd";
  
  job = "
description \"DHCP server\"

start on network-interfaces/started
stop on network-interfaces/stop

script

    mkdir -m 755 -p ${stateDir}

    touch ${stateDir}/dhcpd.leases

    exec ${dhcp}/sbin/dhcpd -f -cf ${configFile} \\
        -lf ${stateDir}/dhcpd.leases \\
        ${toString interfaces}

end script
  ";
  
}
