{utillinux, swapDevices}:

{
  name = "swap";
  
  job = "
start on startup

script
    for device in ${toString swapDevices}; do
        # !!! Check whether we are already swapping to $device.
        ${utillinux}/sbin/swapon \"$device\" || true
    done

    # Remove swap devices not listed in swapDevices.
    for used in $(cat /proc/swaps | grep '^/' | sed 's/ .*//'); do
        found=
        for device in ${toString swapDevices}; do
            if test \"$used\" = \"$device\"; then found=1; fi
        done
        if test -z \"$found\"; then
            ${utillinux}/sbin/swapoff \"$used\" || true
        fi
    done
    
end script
  ";

}
