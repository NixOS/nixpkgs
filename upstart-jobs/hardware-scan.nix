{modprobe, doHardwareScan, kernelModules}:

{
  name = "hardware-scan";
  
  job = "
start on udev

script
    for i in ${toString kernelModules}; do
        echo \"Loading kernel module $i...\"
        ${modprobe}/sbin/modprobe $i || true
    done

    if test -n \"${toString doHardwareScan}\" -a ! -e /var/run/safemode; then
    
        # Try to load modules for all PCI devices.
        for i in /sys/bus/pci/devices/*/modalias; do
            echo \"Trying to load a module for $(basename $(dirname $i))...\"
            ${modprobe}/sbin/modprobe $(cat $i) || true
            echo \"\"
        done

    fi
end script

  ";

}
