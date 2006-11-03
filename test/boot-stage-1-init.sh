#! @shell@

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
mount -t proc proc /proc
mkdir /sys
mount -t sysfs sys /sys

# Create device nodes in /dev.
source @makeDevices@

# Load some kernel modules.
export MODULE_DIR=@kernel@
modprobe ide_disk

# Start an interactive shell.
exec @shell@
