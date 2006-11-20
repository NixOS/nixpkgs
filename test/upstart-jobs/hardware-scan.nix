# !!! Don't like it that I have to pass the kernel here.
{kernel, module_init_tools}:

{
  name = "hardware-scan";
  
  job = "
start on startup

script
    export MODULE_DIR=${kernel}/lib/modules/
    
    # Try to load modules for all PCI devices.
    for i in /sys/bus/pci/devices/*/modalias; do
        echo \"Trying to load a module for $(basename $(dirname $i))...\"
        ${module_init_tools}/sbin/modprobe $(cat $i) || true
        echo \"\"
    done
end script

  ";

}
