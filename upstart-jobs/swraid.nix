{kernel, module_init_tools, mdadm}:

let

  tempConf = "/var/state/mdadm.conf";

in
  
{
  name = "swraid";
  
  job = "
start on udev
#start on new-devices

script

    # Load the necessary RAID personalities.
    export MODULE_DIR=${kernel}/lib/modules/
    for mod in raid0 raid1 raid5; do
        ${module_init_tools}/sbin/modprobe $mod || true
    done

    # Scan /proc/partitions for RAID devices.
    ${mdadm}/sbin/mdadm --examine --brief --scan -c partitions > ${tempConf}

    # Activate each device found.
    ${mdadm}/sbin/mdadm --assemble -c ${tempConf} --scan

    initctl emit new-devices
    
end script

  ";

}
