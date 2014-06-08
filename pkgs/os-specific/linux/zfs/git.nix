{ stdenv, fetchgit, kernel, spl_git, perl, autoconf, automake, libtool, zlib, libuuid, coreutils, utillinux }:

stdenv.mkDerivation {
  name = "zfs-0.6.3pre-${kernel.version}";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "de39ec11b885f97e6256324ee89eaf75af9852f6";
    sha256 = "02hrhka9hg0vn4z20x7xzwrkr340pv9qwvwj8phjdm5ln321jh33";
  };

  patches = [ ./mount_zfs_prefix.patch ./nix-build.patch ];

  buildInputs = [ spl_git perl autoconf automake libtool zlib libuuid coreutils ];

  # for zdb to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_CFLAGS_LINK = "-lgcc_s";

  preConfigure = ''
    ./autogen.sh

    substituteInPlace ./module/zfs/zfs_ctldir.c    --replace "umount -t zfs"     "${utillinux}/bin/umount -t zfs"
    substituteInPlace ./module/zfs/zfs_ctldir.c    --replace "mount -t zfs"      "${utillinux}/bin/mount -t zfs"
    substituteInPlace ./lib/libzfs/libzfs_mount.c  --replace "/bin/umount"       "${utillinux}/bin/umount"
    substituteInPlace ./lib/libzfs/libzfs_mount.c  --replace "/bin/mount"        "${utillinux}/bin/mount"
    substituteInPlace ./udev/rules.d/*             --replace "/lib/udev/vdev_id" "$out/lib/udev/vdev_id"
    substituteInPlace ./cmd/ztest/ztest.c          --replace "/usr/sbin/ztest"   "$out/sbin/ztest"
    substituteInPlace ./cmd/ztest/ztest.c          --replace "/usr/sbin/zdb"     "$out/sbin/zdb"
  '';

  configureFlags = ''
    --disable-systemd
    --with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source
    --with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
    --with-spl=${spl_git}/libexec/spl
  '';

  enableParallelBuilding = true;

  meta = {
    description = "ZFS Filesystem Linux Kernel module";
    longDescription = ''
      ZFS is a filesystem that combines a logical volume manager with a
      Copy-On-Write filesystem with data integrity detection and repair,
      snapshotting, cloning, block devices, deduplication, and more.
      '';
    homepage = http://zfsonlinux.org/;
    license = stdenv.lib.licenses.cddl;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ wizeman ];
  };
}
