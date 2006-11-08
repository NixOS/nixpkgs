#! @shell@

# Syntax: installer.sh <DEVICE> <NIX-EXPR>
# (e.g., installer.sh /dev/hda1 ./my-machine.nix)

# - mount target device
# - make Nix store etc.
# - copy closure of rescue env to target device
# - register validity
# - start the "target" installer in a chroot to the target device
#   * do a nix-pull
#   * nix-env -p system-profile -i <nix-expr for the configuration>
#   * run hook scripts provided by packages in the configuration?
# - install/update grub

targetDevice="$1"

if test -z "$targetDevice"; then
    echo "syntax: installer.sh <targetDevice>"
    exit 1
fi


# Make sure that the target device isn't mounted.
umount "$targetDevice" 2> /dev/null


# Check it.
fsck "$targetDevice" || exit 1


# Mount the target device.
mountPoint=/tmp/inst-mnt
mkdir -p $mountPoint
mount "$targetDevice" $mountPoint || exit 1


# Copy Nix to the Nix store on the target device.
mkdir -p $mountPoint/nix/store/
rsync -av $(cat @nixClosure@) $mountPoint/nix/store/ || exit 1

