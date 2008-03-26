args: with args;
{
  name = "bitlbee";

  users = [
    { name = "bitlbee";
      uid = (import ../system/ids.nix).uids.bitlbee;
      description = "BitlBee user";
      home = "/var/empty";
    }
  ];
  
  job = "
description \"BitlBee IRC to other chat networks gateway\"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    if ! test -d /var/lib/bitlbee
    then
        mkdir -p /var/lib/bitlbee
    fi
end script

# FIXME: Eventually we want to use inetd instead of using `-F'.
respawn ${bitlbee}/sbin/bitlbee -F -p ${portNumber} -i ${interface}
  ";
  
}
