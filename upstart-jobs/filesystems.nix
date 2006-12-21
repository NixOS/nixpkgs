{utillinux, fileSystems}:

let

  # !!! use XML
  mountPoints = map (fs: fs.mountPoint) fileSystems;
  devices = map (fs: fs.device) fileSystems;

in 

{
  name = "filesystems";
  
  job = "
start on startup
start on new-devices

script
    mountPoints=(${toString mountPoints})  
    devices=(${toString devices})

    for ((n = 0; n < \${#mountPoints[*]}; n++)); do
        mountPoint=\${mountPoints[$n]}
        device=\${devices[$n]}

        # If $device is already mounted somewhere else, unmount it first.
        prevMountPoint=$(cat /proc/mounts | grep \"^$device \" | sed 's|^[^ ]\\+ \\+\\([^ ]\\+\\).*|\\1|')

        if test \"$prevMountPoint\" = \"$mountPoint\"; then continue; fi

        if test -n \"$prevMountPoint\"; then
            echo \"unmount $device from $prevMountPoint\"
            ${utillinux}/bin/umount \"$prevMountPoint\" || true
        fi

        echo \"mounting $device on $mountPoint\"

        mkdir -p \"$mountPoint\" || true
        ${utillinux}/bin/mount \"$device\" \"$mountPoint\" || true
    done

end script
  ";

}
