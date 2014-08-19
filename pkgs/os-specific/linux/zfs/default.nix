{ stdenv, fetchurl, kernel, spl, perl, autoconf, automake, libtool, zlib, libuuid, coreutils, utillinux }:

stdenv.mkDerivation {
  name = "zfs-0.6.3-${kernel.version}";

  src = fetchurl {
    url = http://archive.zfsonlinux.org/downloads/zfsonlinux/zfs/zfs-0.6.3.tar.gz;
    sha256 = "06rrip9fxn13x6qnyp6br68r9pcygb95lld25hnnj88m2vagvg19";
  };

  patches = [ ./mount_zfs_prefix.patch ./nix-build.patch ];

  buildInputs = [ spl perl autoconf automake libtool zlib libuuid coreutils ];

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

  configureFlags = [
    "--disable-systemd"
    "--with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "--with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "--with-spl=${spl}/libexec/spl"
    "--with-dracutdir=$(out)/lib/dracut"
    "--with-udevdir=$(out)/lib/udev"
  ];

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
    maintainers = with stdenv.lib.maintainers; [ jcumming wizeman ];
  };
}
