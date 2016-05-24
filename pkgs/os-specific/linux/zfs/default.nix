{ stdenv, fetchFromGitHub, autoreconfHook, utillinux, nukeReferences, coreutils
, configFile ? "all"

# Userspace dependencies
, zlib, libuuid, python

# Kernel dependencies
, kernel ? null, spl ? null
}:

with stdenv.lib;
let
  buildKernel = any (n: n == configFile) [ "kernel" "all" ];
  buildUser = any (n: n == configFile) [ "user" "all" ];
in

assert any (n: n == configFile) [ "kernel" "user" "all" ];
assert buildKernel -> kernel != null && spl != null;

stdenv.mkDerivation rec {
  name = "zfs-${configFile}-${version}${optionalString buildKernel "-${kernel.version}"}";

  version = "0.6.5.7";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "zfs";
    rev = "zfs-${version}";
    sha256 = "17mshxyp8k7i9a7ys0rznhkz83f6650pby9ka48d6gzgcwv9nnsm";
  };

  patches = [ ./nix-build.patch ];

  buildInputs = [ autoreconfHook nukeReferences ]
    ++ optionals buildKernel [ spl ]
    ++ optionals buildUser [ zlib libuuid python ];

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
    substituteInPlace ./module/Makefile.in        --replace "/bin/cp"                 "cp"
    substituteInPlace ./etc/systemd/system/zfs-share.service.in \
        --replace "@bindir@/rm " "${coreutils}/bin/rm "
    ./autogen.sh
  '';

  configureFlags = [
    "--with-config=${configFile}"
  ] ++ optionals buildUser [
    "--with-dracutdir=$(out)/lib/dracut"
    "--with-udevdir=$(out)/lib/udev"
    "--with-systemdunitdir=$(out)/etc/systemd/system"
    "--with-systemdpresetdir=$(out)/etc/systemd/system-preset"
    "--with-mounthelperdir=$(out)/bin"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-systemd"
  ] ++ optionals buildKernel [
    "--with-spl=${spl}/libexec/spl"
    "--with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "--with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=\${out}/etc"
    "DEFAULT_INITCONF_DIR=\${out}/default"
  ];

  postInstall = ''
    # Prevent kernel modules from depending on the Linux -dev output.
    nuke-refs $(find $out -name "*.ko")
  '' + optionalString buildUser ''
    # Remove provided services as they are buggy
    rm $out/etc/systemd/system/zfs-import-*.service

    sed -i '/zfs-import-scan.service/d' $out/etc/systemd/system/*

    for i in $out/etc/systemd/system/*; do
      substituteInPlace $i --replace "zfs-import-cache.service" "zfs-import.target"
    done

    # Fix pkgconfig.
    ln -s ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = {
    description = "ZFS Filesystem Linux Kernel module";
    longDescription = ''
      ZFS is a filesystem that combines a logical volume manager with a
      Copy-On-Write filesystem with data integrity detection and repair,
      snapshotting, cloning, block devices, deduplication, and more.
      '';
    homepage = http://zfsonlinux.org/;
    license = licenses.cddl;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jcumming wizeman wkennington ];
  };
}
