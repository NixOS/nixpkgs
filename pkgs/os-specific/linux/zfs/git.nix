{ stdenv, fetchgit, kernel, spl_git, perl, autoconf, automake, libtool, zlib, libuuid, coreutils, utillinux }:

stdenv.mkDerivation {
  name = "zfs-0.6.3-${kernel.version}";

  src = fetchgit {
    url = git://github.com/zfsonlinux/zfs.git;
    rev = "07dabd234dd51a1e5adc5bd21cddf5b5fdc70732";
    sha256 = "1yqsfdhyzh33aisfvwqd692n5kfgnlz7yjixd2gqn8vx9bv0dz0b";
  };

  patches = [ ./mount_zfs_prefix.patch ./nix-build.patch ./bc151f7b312dea09c6ec5b9a320e65140789643a.patch ];

  buildInputs = [ spl_git perl autoconf automake libtool zlib libuuid coreutils ];

  # for zdb to get the rpath to libgcc_s, needed for pthread_cancel to work
  NIX_CFLAGS_LINK = "-lgcc_s";

  preConfigure = ''
    substituteInPlace ./module/zfs/zfs_ctldir.c   --replace "umount -t zfs"           "${utillinux}/bin/umount -t zfs"
    substituteInPlace ./module/zfs/zfs_ctldir.c   --replace "mount -t zfs"            "${utillinux}/bin/mount -t zfs"
    substituteInPlace ./lib/libzfs/libzfs_mount.c --replace "/bin/umount"             "${utillinux}/bin/umount"
    substituteInPlace ./lib/libzfs/libzfs_mount.c --replace "/bin/mount"              "${utillinux}/bin/mount"
    substituteInPlace ./udev/rules.d/*            --replace "/lib/udev/vdev_id"       "$out/lib/udev/vdev_id"
    substituteInPlace ./cmd/ztest/ztest.c         --replace "/usr/sbin/ztest"         "$out/sbin/ztest"
    substituteInPlace ./cmd/ztest/ztest.c         --replace "/usr/sbin/zdb"           "$out/sbin/zdb"
    substituteInPlace ./config/user-systemd.m4    --replace "/usr/lib/modules-load.d" "$out/etc/modules-load.d"
    substituteInPlace ./config/zfs-build.m4       --replace "\$sysconfdir/init.d"     "$out/etc/init.d"
    substituteInPlace ./etc/zfs/Makefile.am       --replace "\$(sysconfdir)"          "$out/etc"
    substituteInPlace ./cmd/zed/Makefile.am       --replace "\$(sysconfdir)"          "$out/etc"

    ./autogen.sh
  '';

  configureFlags = [
    "--enable-systemd"
    "--with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "--with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "--with-spl=${spl_git}/libexec/spl"
    "--with-dracutdir=$(out)/lib/dracut"
    "--with-udevdir=$(out)/lib/udev"
    "--with-systemdunitdir=$(out)/etc/systemd/system"
    "--with-systemdpresetdir=$(out)/etc/systemd/system-preset"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  enableParallelBuilding = true;

  # Remove provided services as they are buggy
  postInstall = ''
    rm $out/etc/systemd/system/zfs-import-*.service

    sed -i '/zfs-import-scan.service/d' $out/etc/systemd/system/*

    for i in $out/etc/systemd/system/*; do
      substituteInPlace $i --replace "zfs-import-cache.service" "zfs-import.target"
    done
  '';

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
