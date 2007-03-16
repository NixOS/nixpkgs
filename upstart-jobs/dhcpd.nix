{dhcp, configFile, interfaces}:

{
  name = "dhcpd";
  
  job = "
description \"DHCP server\"

start on network-interfaces/started
stop on network-interfaces/stop

script
    exec ${dhcp}/sbin/dhcpd -f -cf ${configFile} ${toString interfaces}
end script
  ";
  
}
