# !!! Don't like it that I have to pass the kernel here.
{ nettools, kernel, module_init_tools
, nameservers, defaultGateway, interfaces
}:

let

  # !!! use XML
  names = map (i: i.name) interfaces;
  ipAddresses = map (i: i.ipAddress) interfaces;
  subnetMasks = map (i: if i ? subnetMask then i.subnetMask else "default") interfaces;

in 

{
  name = "network-interfaces";
  
  job = "
start on hardware-scan
stop on shutdown

start script
    export MODULE_DIR=${kernel}/lib/modules/

    ${module_init_tools}/sbin/modprobe af_packet

    for i in $(cd /sys/class/net && ls -d *); do
        echo \"Bringing up network device $i...\"
        ${nettools}/sbin/ifconfig $i up || true
    done

    # Configure the manually specified interfaces.
    names=(${toString names})
    ipAddresses=(${toString ipAddresses})
    subnetMasks=(${toString subnetMasks})

    for ((n = 0; n < \${#names[*]}; n++)); do
        name=\${names[$n]}
        ipAddress=\${ipAddresses[$n]}
        subnetMask=\${subnetMasks[$n]}
        echo \"Configuring interface $name...\"
	extraFlags=
        if test \"$subnetMask\" != default; then
	    extraFlags=\"$extraFlags netmask $subnetMask\"
        fi
        ${nettools}/sbin/ifconfig \"$name\" \"$ipAddress\" $extraFlags || true
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

end script

# Hack: Upstart doesn't yet support what we want: a service that
# doesn't have a running process associated with it.
respawn sleep 10000

stop script
    for i in $(cd /sys/class/net && ls -d *); do
        echo \"Taking down network device $i...\"
        ${nettools}/sbin/ifconfig $i down || true
    done
end script

  ";
  
}
