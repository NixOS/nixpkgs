source $stdenv/setup

export MOUNT_FUSE_PATH=$out/sbin
export INIT_D_PATH=$out/etc/init.d
export UDEV_RULES_PATH=$out/etc/udev/rules.d

# This is ugly.  Normally, FUSE executes $out/bin/fusermount to mount
# the file system.  However, fusermount should be setuid root, but Nix
# doesn't support setuid binaries, so fusermount will fail.  By
# setting FUSERMOUNT_DIR to a non-existant path, FUSE will fall back
# to searching for fusermount in $PATH.  The user is responsible for
# (e.g.) setting up a setuid-wrapper for fusermount and adding it to
# $PATH.
export NIX_CFLAGS_COMPILE="-DFUSERMOUNT_DIR=\"/no-such-path\""

export preBuild="sed -e 's@/bin/@$utillinux/bin/@g' -i lib/mount_util.c";

genericBuild
