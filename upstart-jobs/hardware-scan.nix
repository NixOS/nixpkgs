# !!! Don't like it that I have to pass the kernel here.
{kernel, module_init_tools, doHardwareScan, kernelModules}:

{
  name = "hardware-scan";
  
  job = "
start on udev

script
    export MODULE_DIR=${kernel}/lib/modules/

    for i in ${toString kernelModules}; do
        echo \"Loading kernel module $i...\"
        ${module_init_tools}/sbin/modprobe $i || true
    done

    if test -n \"${toString doHardwareScan}\" -a ! -e /var/run/safemode; then
    
        # Try to load modules for all PCI devices.
        for i in /sys/bus/pci/devices/*/modalias; do
            echo \"Trying to load a module for $(basename $(dirname $i))...\"
            ${module_init_tools}/sbin/modprobe $(cat $i) || true
            echo \"\"
        done

    fi
end script

  ";

}
