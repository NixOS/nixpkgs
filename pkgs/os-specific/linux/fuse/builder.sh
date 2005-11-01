source $stdenv/setup

export MOUNT_FUSE_PATH=$out/sbin

installPhase () {
    # !!! quick hack to get fuse to install; it currently tries to
    # install a device node /dev/fuse.
    make install || true
}

genericBuild