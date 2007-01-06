source $stdenv/setup

export MOUNT_FUSE_PATH=$out/sbin
export INIT_D_PATH=$out/etc/init.d
export UDEV_RULES_PATH=$out/etc/udev/rules.d

genericBuild
