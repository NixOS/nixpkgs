{utillinux, e2fsprogs, fileSystems}:

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
    PATH=${e2fsprogs}/sbin:$PATH

    mountPoints=(${toString mountPoints})  
    devices=(${toString devices})
    fsTypes=(${toString fsTypes})
    optionss=(${toString optionss})

    newDevices=1

    # If we mount any file system, we repeat this loop, because new
    # mount opportunities may have become available (such as images
    # for loopback mounts).
    
    while test -n \"$newDevices\"; do

        newDevices=

        for ((n = 0; n < \${#mountPoints[*]}; n++)); do
            mountPoint=\${mountPoints[$n]}
            device=\${devices[$n]}
            fsType=\${fsTypes[$n]}
            options=\${optionss[$n]}

            isLabel=
            if echo \"$device\" | grep -q '^LABEL='; then isLabel=1; fi

            if ! test -n \"$isLabel\" -o -e \"$device\"; then
                echo \"skipping $device, doesn't exist (yet)\"
                continue
            fi

            # If $device is already mounted somewhere else, unmount it first.
            # !!! Note: we use /etc/mtab, not /proc/mounts, because mtab
            # contains more accurate info when using loop devices.

            # !!! not very smart about labels yet; should resolve the label somehow.
            if test -z \"$isLabel\"; then

                device=$(readlink -f \"$device\")

                prevMountPoint=$(
                    cat /etc/mtab \\
                    | grep \"^$device \" \\
                    | sed 's|^[^ ]\\+ \\+\\([^ ]\\+\\).*|\\1|' \\
                )

                if test \"$prevMountPoint\" = \"$mountPoint\"; then
                     echo \"remounting $device on $mountPoint\"
                     ${utillinux}/bin/mount -t \"$fsType\" \\
                         -o remount,\"$options\" \\
                         \"$device\" \"$mountPoint\" || true
                     continue
                fi

                if test -n \"$prevMountPoint\"; then
                    echo \"unmount $device from $prevMountPoint\"
                    ${utillinux}/bin/umount \"$prevMountPoint\" || true
                fi

            fi

            echo \"mounting $device on $mountPoint\"

            # !!! should do something with the result; also prevent repeated fscks.
            fsck -a \"$device\" || true

            if ${utillinux}/bin/mount -t \"$fsType\" -o \"$options\" \"$device\" \"$mountPoint\"; then
                newDevices=1
            fi
        
        done

    done

end script
  ";

}
