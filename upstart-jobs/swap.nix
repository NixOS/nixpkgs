{pkgs, config, ...}:

###### implementation

let

  inherit (pkgs) utillinux lib;

  swapDevices = config.swapDevices;

  devicesByPath =
    map (x: x.device) (lib.filter (x: x ? device) swapDevices);
    
  devicesByLabel =
    map (x: x.label) (lib.filter (x: x ? label) swapDevices);

in


{
  services = {
    extraJobs = [{
      name = "swap";
      
      job = "
        start on startup
        start on new-devices
        
        script
            for device in ${toString devicesByPath}; do
                ${utillinux}/sbin/swapon \"$device\" || true
            done
            
            for label in ${toString devicesByLabel}; do
                ${utillinux}/sbin/swapon -L \"$label\" || true
            done
            
            # Remove swap devices not listed in swapDevices.
            # !!! disabled because it doesn't work with labels
            #for used in $(cat /proc/swaps | grep '^/' | sed 's/ .*//'); do
            #    found=
            #    for device in $ {toString swapDevices}; do
            #        if test \"$used\" = \"$device\"; then found=1; fi
            #    done
            #    if test -z \"$found\"; then
            #        ${utillinux}/sbin/swapoff \"$used\" || true
            #    fi
            #done
            
        end script
      ";
    }];
  };
}
