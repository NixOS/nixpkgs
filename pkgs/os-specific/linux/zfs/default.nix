{ stdenv, fetchFromGitHub, autoreconfHook, utillinux, nukeReferences, coreutils
, perl
, configFile ? "all"

# Userspace dependencies
, zlib, libuuid, python3, attr, openssl
, libtirpc
, nfs-utils
, gawk, gnugrep, gnused, systemd

# Kernel dependencies
, kernel ? null
}:

with stdenv.lib;
let
  buildKernel = any (n: n == configFile) [ "kernel" "all" ];
  buildUser = any (n: n == configFile) [ "user" "all" ];

  common = { version
    , sha256
    , extraPatches
    , rev ? "zfs-${version}"
    , isUnstable ? false
    , incompatibleKernelVersion ? null }:
    if buildKernel &&
      (incompatibleKernelVersion != null) &&
        versionAtLeast kernel.version incompatibleKernelVersion then
       throw ''
         Linux v${kernel.version} is not yet supported by zfsonlinux v${version}.
         ${stdenv.lib.optionalString (!isUnstable) "Try zfsUnstable or set the NixOS option boot.zfs.enableUnstable."}
       ''
    else stdenv.mkDerivation rec {
      name = "zfs-${configFile}-${version}${optionalString buildKernel "-${kernel.version}"}";

      src = fetchFromGitHub {
        owner = "zfsonlinux";
        repo = "zfs";
        inherit rev sha256;
      };

      patches = extraPatches;

      postPatch = optionalString buildKernel ''
        patchShebangs scripts
      '' + optionalString stdenv.hostPlatform.isMusl ''
        substituteInPlace config/user-libtirpc.m4 \
          --replace /usr/include/tirpc ${libtirpc}/include/tirpc
      '';

      nativeBuildInputs = [ autoreconfHook nukeReferences ]
        ++ optional buildKernel (kernel.moduleBuildDependencies ++ [ perl ]);
      buildInputs = optionals buildUser [ zlib libuuid python3 attr ]
        ++ optionals (buildUser) [ openssl ]
        ++ optional stdenv.hostPlatform.isMusl [ libtirpc ];

      # for zdb to get the rpath to libgcc_s, needed for pthread_cancel to work
      NIX_CFLAGS_LINK = "-lgcc_s";

      hardeningDisable = [ "fortify" "stackprotector" "pic" ];

      preConfigure = ''
        substituteInPlace ./module/zfs/zfs_ctldir.c   --replace "umount -t zfs"           "${utillinux}/bin/umount -t zfs"
        substituteInPlace ./module/zfs/zfs_ctldir.c   --replace "mount -t zfs"            "${utillinux}/bin/mount -t zfs"
        substituteInPlace ./lib/libzfs/libzfs_mount.c --replace "/bin/umount"             "${utillinux}/bin/umount"
        substituteInPlace ./lib/libzfs/libzfs_mount.c --replace "/bin/mount"              "${utillinux}/bin/mount"
        substituteInPlace ./lib/libshare/nfs.c        --replace "/usr/sbin/exportfs"      "${nfs-utils}/bin/exportfs"
        substituteInPlace ./cmd/ztest/ztest.c         --replace "/usr/sbin/ztest"         "$out/sbin/ztest"
        substituteInPlace ./cmd/ztest/ztest.c         --replace "/usr/sbin/zdb"           "$out/sbin/zdb"
        substituteInPlace ./config/user-systemd.m4    --replace "/usr/lib/modules-load.d" "$out/etc/modules-load.d"
        substituteInPlace ./config/zfs-build.m4       --replace "\$sysconfdir/init.d"     "$out/etc/init.d"
        substituteInPlace ./etc/zfs/Makefile.am       --replace "\$(sysconfdir)"          "$out/etc"
        substituteInPlace ./cmd/zed/Makefile.am       --replace "\$(sysconfdir)"          "$out/etc"
        substituteInPlace ./module/Makefile.in        --replace "/bin/cp"                 "cp"
        substituteInPlace ./etc/systemd/system/zfs-share.service.in \
          --replace "/bin/rm " "${coreutils}/bin/rm "

        for f in ./udev/rules.d/*
        do
          substituteInPlace "$f" --replace "/lib/udev/vdev_id" "$out/lib/udev/vdev_id"
        done
        substituteInPlace ./cmd/vdev_id/vdev_id \
          --replace "PATH=/bin:/sbin:/usr/bin:/usr/sbin" \
          "PATH=${makeBinPath [ coreutils gawk gnused gnugrep systemd ]}"

        ./autogen.sh
        configureFlagsArray+=("--libexecdir=$out/libexec")
      '';

      configureFlags = [
        "--with-config=${configFile}"
        "--with-python=${python3.interpreter}"
      ] ++ optionals buildUser [
        "--with-dracutdir=$(out)/lib/dracut"
        "--with-udevdir=$(out)/lib/udev"
        "--with-systemdunitdir=$(out)/etc/systemd/system"
        "--with-systemdpresetdir=$(out)/etc/systemd/system-preset"
        "--with-systemdgeneratordir=$(out)/lib/systemd/system-generator"
        "--with-mounthelperdir=$(out)/bin"
        "--sysconfdir=/etc"
        "--localstatedir=/var"
        "--enable-systemd"
      ] ++ optionals buildKernel [
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

        # Remove tests because they add a runtime dependency on gcc
        rm -rf $out/share/zfs/zfs-tests

        # Add Bash completions.
        install -v -m444 -D -t $out/share/bash-completion/completions contrib/bash_completion.d/zfs
        (cd $out/share/bash-completion/completions; ln -s zfs zpool)
      '';

      outputs = [ "out" ] ++ optionals buildUser [ "lib" "dev" ];

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
        maintainers = with maintainers; [ jcumming wizeman fpletz globin ];
      };
    };
in {
  # also check if kernel version constraints in
  # ./nixos/modules/tasks/filesystems/zfs.nix needs
  # to be adapted
  zfsStable = common {
    # comment/uncomment if breaking kernel versions are known
    # incompatibleKernelVersion = "4.20";

    # this package should point to the latest release.
    version = "0.8.1";

    sha256 = "0wlbziijx08a9bmbyq4gfz4by9l5jrx44g18i99qnfm78k2q8a84";

    extraPatches = [
      ./build-fixes-unstable.patch
    ];
  };

  zfsUnstable = common rec {
    # comment/uncomment if breaking kernel versions are known
    # incompatibleKernelVersion = "4.19";

    # this package should point to a version / git revision compatible with the latest kernel release
    # This is now "stable". Move to zfsStable after it's tested more.
    version = "0.8.1";

    sha256 = "0wlbziijx08a9bmbyq4gfz4by9l5jrx44g18i99qnfm78k2q8a84";
    isUnstable = true;

    extraPatches = [
      ./build-fixes-unstable.patch
    ];
  };
}
