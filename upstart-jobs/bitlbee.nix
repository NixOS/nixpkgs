args: with args;

let
  bitlbeeUid = (import ../system/ids.nix).uids.bitlbee;
in
{
  name = "bitlbee";

  users = [
    { name = "bitlbee";
      uid = bitlbeeUid;
      description = "BitlBee user";
      home = "/var/empty";
    }
  ];
  
  groups = [
    { name = "bitlbee";
      gid = (import ../system/ids.nix).gids.bitlbee;
    }
  ];

  job = ''
description "BitlBee IRC to other chat networks gateway"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    if ! test -d /var/lib/bitlbee
    then
        mkdir -p /var/lib/bitlbee
    fi
end script

respawn ${bitlbee}/sbin/bitlbee -F -p ${toString portNumber} \
        -i ${interface} -u bitlbee
  '';
  
}
