{dhcp, nettools, interfaces, lib}:

let 

  # Don't start dhclient on explicitly configured interfaces.
  ignoredInterfaces = ["lo"] ++
    map (i: i.name) (lib.filter (i: i ? ipAddress) interfaces);

  stateDir = "/var/lib/dhcp"; # Don't use /var/state/dhcp; not FHS-compliant.

in

{
  name = "dhclient";
  
  job = "
description \"DHCP client\"

start on network-interfaces/started
stop on network-interfaces/stop

env PATH_DHCLIENT_SCRIPT=${dhcp}/sbin/dhclient-script

script
    export PATH=${nettools}/sbin:$PATH

    # Determine the interface on which to start dhclient.
    interfaces=

    for i in $(cd /sys/class/net && ls -d *); do
        if ! for j in ${toString ignoredInterfaces}; do echo $j; done | grep -F -x -q \"$i\"; then
            echo \"Running dhclient on $i\"
            interfaces=\"$interfaces $i\"
        fi
    done

    if test -z \"$interfaces\"; then
        echo 'No interfaces on which to start dhclient!'
        exit 1
    fi

    mkdir -m 755 -p ${stateDir}

    exec ${dhcp}/sbin/dhclient -d $interfaces -e \"PATH=$PATH\" -lf ${stateDir}/dhclient.leases
end script
  ";
  
}
