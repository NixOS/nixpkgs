{dhcp}:

{
  name = "dhclient";
  
  job = "
description \"DHCP client\"

start on startup
stop on shutdown

script
    interfaces=
    for i in $(cd /sys/class/net && ls -d *); do
        if test \"$i\" != \"lo\" -a \"$(cat /sys/class/net/$i/operstate)\" != 'down'; then
            interfaces=\"$interfaces $i\"
        fi
    done

    if test -z \"$interfaces\"; then
        echo 'No interfaces on which to start dhclient!'
        exit 1
    fi

    exec ${dhcp}/sbin/dhclient -d $interfaces
end script
  ";
  
}
