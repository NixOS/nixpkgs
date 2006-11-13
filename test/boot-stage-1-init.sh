#! @shell@

fail() {
    # If starting stage 2 failed, start an interactive shell.
    echo "Stage 2 failed, starting emergency shell..."
    exec @shell@
}


# Print a greeting.
echo
echo "<<< NixOS Stage 1 >>>"
echo


# Set the PATH.
export PATH=/empty
for i in @path@; do
    PATH=$PATH:$i/bin
    if test -e $i/sbin; then
        PATH=$PATH:$i/sbin
    fi
done


# Mount special file systems.
mkdir /etc # to shut up mount
touch /etc/fstab # idem
mkdir /proc
mount -t proc none /proc
mkdir /sys
mount -t sysfs none /sys


# Create device nodes in /dev.
source @makeDevices@


# Load some kernel modules.
export MODULE_DIR=@modules@/lib/modules/
modprobe ide-generic
modprobe ide-disk
modprobe ide-cd


# Try to find and mount the root device.
mkdir /mnt
mkdir /mnt/root

echo "mounting the root device..."

if test -n "@autoDetectRootDevice@"; then

    # Look for the root device by label.
    echo "probing for the NixOS installation CD..."

    for i in /sys/devices/*/*/media; do
        if test "$(cat $i)" = "cdrom"; then

            # Hopefully `drivename' matches the device created in /dev.
            devName=/dev/$(cat $(dirname $i)/drivename)

            echo "  in $devName..."

            if mount -o ro -t iso9660 $devName /mnt/root; then
                if test -e "/mnt/root/@rootLabel@"; then
                    found=1
                    break
                fi
                umount /mnt/root
            fi
        
        fi
    done

    if test -z "$found"; then
        echo "CD not found!"
        fail
    fi

else

    # Hard-coded root device.
    mount -o ro "@rootDevice@" /mnt/root

fi

# Start stage 2.
# !!! Note: we can't use pivot_root here (the kernel gods have
# decreed), but we could use run-init from klibc, which deletes all
# files in the initramfs, remounts the target root on /, and chroots.
cd /mnt/root
mount --move . /
umount /proc # cleanup
umount /sys

exec chroot . @stage2Init@

fail
