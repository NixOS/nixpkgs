{dhcp, nettools}:

{
  name = "dhclient";
  
  job = "
description \"DHCP client\"

start on network-interfaces/started
stop on network-interfaces/stop

env PATH_DHCLIENT_SCRIPT=${dhcp}/sbin/dhclient-script

script
    # Determine the interface on which to start dhclient.
    interfaces=

    # !!! apparent race; operstate seems to have a slight delay, so
    # if dhclient is started right after network-interfaces, we don't
    # always see all the interfaces.

    #for i in $(cd /sys/class/net && ls -d *); do
    #    if test \"$i\" != \"lo\" -a \"$(cat /sys/class/net/$i/operstate)\" != 'down'; then
    #        interfaces=\"$interfaces $i\"
    #    fi
    #done

    for i in $(${nettools}/sbin/ifconfig | grep '^[^ ]' | sed 's/ .*//'); do
        if test \"$i\" != \"lo\"; then
            interfaces=\"$interfaces $i\"
        fi
    done

    if test -z \"$interfaces\"; then
        echo 'No interfaces on which to start dhclient!'
        exit 1
    fi

    mkdir -m 755 -p /var/state/dhcp

    exec ${dhcp}/sbin/dhclient -d $interfaces
end script
  ";
  
}
