# !!! Don't like it that I have to pass the kernel here.
{nettools, kernel}:

{
  name = "network-interfaces";
  
  job = "
start on startup
stop on shutdown

start script
    export MODULE_DIR=${kernel}/lib/modules/

    modprobe af_packet
    
    for i in $(cd /sys/class/net && ls -d *); do
        echo \"Bringing up network device $i...\"
        ${nettools}/sbin/ifconfig $i up || true
    done
end script

# Hack: Upstart doesn't yet support what we want: a service that
# doesn't have a running process associated with it.
respawn sleep 10000

stop script
    for i in $(cd /sys/class/net && ls -d *); do
        echo \"Bringing up network device $i...\"
        ${nettools}/sbin/ifconfig $i down || true
    done
end script

  ";
  
}
