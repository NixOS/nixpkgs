{utillinux, fileSystems}:

let

  # !!! use XML
  mountPoints = map (fs: fs.mountPoint) fileSystems;
  devices = map (fs: fs.device) fileSystems;
  fsTypes = map (fs: if fs ? fsType then fs.fsType else "auto") fileSystems;
  optionss = map (fs: if fs ? options then fs.options else "defaults") fileSystems;

in 

{
  name = "filesystems";
  
  job = "
start on startup
start on new-devices

script
    mountPoints=(${toString mountPoints})  
    devices=(${toString devices})
    fsTypes=(${toString fsTypes})
    optionss=(${toString optionss})

    for ((n = 0; n < \${#mountPoints[*]}; n++)); do
        mountPoint=\${mountPoints[$n]}
        device=\${devices[$n]}
        fsType=\${fsTypes[$n]}
        options=\${optionss[$n]}

        # If $device is already mounted somewhere else, unmount it first.
        prevMountPoint=$(cat /proc/mounts | grep \"^$device \" | sed 's|^[^ ]\\+ \\+\\([^ ]\\+\\).*|\\1|')

        if test \"$prevMountPoint\" = \"$mountPoint\"; then
             echo \"remounting $device on $mountPoint\"
             ${utillinux}/bin/mount -t \"$fsType\" -o remount,\"$options\" \"$device\" \"$mountPoint\" || true
             continue
        fi

        if test -n \"$prevMountPoint\"; then
            echo \"unmount $device from $prevMountPoint\"
            ${utillinux}/bin/umount \"$prevMountPoint\" || true
        fi

        echo \"mounting $device on $mountPoint\"

        mkdir -p \"$mountPoint\" || true
        ${utillinux}/bin/mount -t \"$fsType\" -o \"$options\" \"$device\" \"$mountPoint\" || true
    done

end script
  ";

}
