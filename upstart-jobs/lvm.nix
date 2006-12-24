{kernel, module_init_tools, lvm2}:

{
  name = "lvm";
  
  job = "
start on udev
#start on new-devices

script

    # Load the device mapper.
    export MODULE_DIR=${kernel}/lib/modules/
    ${module_init_tools}/sbin/modprobe dm_mod || true

    # Scan for block devices that might contain LVM physical volumes
    # and volume groups.
    #${lvm2}/sbin/vgscan

    # Make all logical volumes on all volume groups available, i.e.,
    # make them appear in /dev.
    ${lvm2}/sbin/vgchange --available y

    initctl emit new-devices
    
end script

  ";

}
