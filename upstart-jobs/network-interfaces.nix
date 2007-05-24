{ nettools, modprobe, wirelesstools, bash, writeText
, nameservers, defaultGateway, interfaces
, localCommands
}:

let

  # !!! use XML
  names = map (i: i.name) interfaces;
  ipAddresses = map (i: if i ? ipAddress then i.ipAddress else "dhcp") interfaces;
  subnetMasks = map (i: if i ? subnetMask then i.subnetMask else "default") interfaces;
  essids = map (i: if i ? essid then i.essid else "default") interfaces;
  wepKeys = map (i: if i ? wepKey then i.wepKey else "nokey") interfaces;

in 

{
  name = "network-interfaces";
  
  job = "
start on hardware-scan
stop on shutdown

start script
    export PATH=${modprobe}/sbin:$PATH
    modprobe af_packet || true

    for i in $(cd /sys/class/net && ls -d *); do
        echo \"Bringing up network device $i...\"
        ${nettools}/sbin/ifconfig $i up || true
    done

    # Configure the manually specified interfaces.
    names=(${toString names})
    ipAddresses=(${toString ipAddresses})
    subnetMasks=(${toString subnetMasks})
    essids=(${toString essids})
    wepKeys=(${toString wepKeys})

    for ((n = 0; n < \${#names[*]}; n++)); do
        name=\${names[$n]}
        ipAddress=\${ipAddresses[$n]}
        subnetMask=\${subnetMasks[$n]}
        essid=\${essids[$n]}
        wepKey=\${wepKeys[$n]}

        # Set wireless networking stuff.
        if test \"$essid\" != default; then
            ${wirelesstools}/sbin/iwconfig \"$name\" essid \"$essid\" || true
        fi
        
        if test \"$wepKey\" != nokey; then
            ${wirelesstools}/sbin/iwconfig \"$name\" key \"$(cat \"$wepKey\")\" || true
        fi
        
        # Set IP address / netmask.        
        if test \"$ipAddress\" != dhcp; then
            echo \"Configuring interface $name...\"
	    extraFlags=
            if test \"$subnetMask\" != default; then
	        extraFlags=\"$extraFlags netmask $subnetMask\"
            fi
            ${nettools}/sbin/ifconfig \"$name\" \"$ipAddress\" $extraFlags || true
        fi
        
    done

    # Set the nameservers.
    if test -n \"${toString nameservers}\"; then
        rm -f /etc/resolv.conf
        for i in ${toString nameservers}; do
            echo \"nameserver $i\" >> /etc/resolv.conf
        done
    fi

    # Set the default gateway.
    if test -n \"${defaultGateway}\"; then
        ${nettools}/sbin/route add default gw \"${defaultGateway}\" || true
    fi

    # Run any user-specified commands.
    ${bash}/bin/sh ${writeText "local-net-cmds" localCommands} || true

end script

# Hack: Upstart doesn't yet support what we want: a service that
# doesn't have a running process associated with it.
respawn sleep 100000

stop script
    for i in $(cd /sys/class/net && ls -d *); do
        echo \"Taking down network device $i...\"
        ${nettools}/sbin/ifconfig $i down || true
    done
end script

  ";
  
}
