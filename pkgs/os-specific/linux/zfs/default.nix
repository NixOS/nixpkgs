{ lib, stdenv, fetchFromGitHub
, autoreconfHook269, util-linux, nukeReferences, coreutils
, perl, nixosTests
, configFile ? "all"

# Userspace dependencies
, zlib, libuuid, python3, attr, openssl
, libtirpc
, nfs-utils
, gawk, gnugrep, gnused, systemd
, smartmontools, enableMail ? false
, sysstat, pkg-config

# Kernel dependencies
, kernel ? null
, enablePython ? true
}:

with lib;
let
  smartmon = smartmontools.override { inherit enableMail; };

  buildKernel = any (n: n == configFile) [ "kernel" "all" ];
  buildUser = any (n: n == configFile) [ "user" "all" ];

  common = { version
    , sha256
    , extraPatches ? []
    , rev ? "zfs-${version}"
    , isUnstable ? false
    , kernelCompatible ? null }:

    stdenv.mkDerivation {
      name = "zfs-${configFile}-${version}${optionalString buildKernel "-${kernel.version}"}";

      src = fetchFromGitHub {
        owner = "zfsonlinux";
        repo = "zfs";
        inherit rev sha256;
      };

      patches = extraPatches;

      postPatch = optionalString buildKernel ''
        patchShebangs scripts
        # The arrays must remain the same length, so we repeat a flag that is
        # already part of the command and therefore has no effect.
        substituteInPlace ./module/os/linux/zfs/zfs_ctldir.c \
          --replace '"/usr/bin/env", "umount"' '"${util-linux}/bin/umount", "-n"' \
          --replace '"/usr/bin/env", "mount"'  '"${util-linux}/bin/mount", "-n"'
      '' + optionalString buildUser ''
        substituteInPlace ./lib/libshare/os/linux/nfs.c --replace "/usr/sbin/exportfs" "${
          # We don't *need* python support, but we set it like this to minimize closure size:
          # If it's disabled by default, no need to enable it, even if we have python enabled
          # And if it's enabled by default, only change that if we explicitly disable python to remove python from the closure
          nfs-utils.override (old: { enablePython = old.enablePython or true && enablePython; })
        }/bin/exportfs"
        substituteInPlace ./config/user-systemd.m4    --replace "/usr/lib/modules-load.d" "$out/etc/modules-load.d"
        substituteInPlace ./config/zfs-build.m4       --replace "\$sysconfdir/init.d"     "$out/etc/init.d" \
                                                      --replace "/etc/default"            "$out/etc/default"
        substituteInPlace ./etc/zfs/Makefile.am       --replace "\$(sysconfdir)"          "$out/etc"

        substituteInPlace ./contrib/initramfs/hooks/Makefile.am \
          --replace "/usr/share/initramfs-tools/hooks" "$out/usr/share/initramfs-tools/hooks"
        substituteInPlace ./contrib/initramfs/Makefile.am \
          --replace "/usr/share/initramfs-tools" "$out/usr/share/initramfs-tools"
        substituteInPlace ./contrib/initramfs/scripts/Makefile.am \
          --replace "/usr/share/initramfs-tools/scripts" "$out/usr/share/initramfs-tools/scripts"
        substituteInPlace ./contrib/initramfs/scripts/local-top/Makefile.am \
          --replace "/usr/share/initramfs-tools/scripts/local-top" "$out/usr/share/initramfs-tools/scripts/local-top"
        substituteInPlace ./contrib/initramfs/scripts/Makefile.am \
          --replace "/usr/share/initramfs-tools/scripts" "$out/usr/share/initramfs-tools/scripts"
        substituteInPlace ./contrib/initramfs/scripts/local-top/Makefile.am \
          --replace "/usr/share/initramfs-tools/scripts/local-top" "$out/usr/share/initramfs-tools/scripts/local-top"
        substituteInPlace ./etc/systemd/system/Makefile.am \
          --replace '$(DESTDIR)$(systemdunitdir)' "$out"'$(DESTDIR)$(systemdunitdir)'

        substituteInPlace ./contrib/initramfs/conf.d/Makefile.am \
          --replace "/usr/share/initramfs-tools/conf.d" "$out/usr/share/initramfs-tools/conf.d"
        substituteInPlace ./contrib/initramfs/conf-hooks.d/Makefile.am \
          --replace "/usr/share/initramfs-tools/conf-hooks.d" "$out/usr/share/initramfs-tools/conf-hooks.d"

        substituteInPlace ./cmd/vdev_id/vdev_id \
          --replace "PATH=/bin:/sbin:/usr/bin:/usr/sbin" \
          "PATH=${makeBinPath [ coreutils gawk gnused gnugrep systemd ]}"
      '';

      nativeBuildInputs = [ autoreconfHook269 nukeReferences ]
        ++ optionals buildKernel (kernel.moduleBuildDependencies ++ [ perl ])
        ++ optional buildUser pkg-config;
      buildInputs = optionals buildUser [ zlib libuuid attr libtirpc ]
        ++ optional buildUser openssl
        ++ optional (buildUser && enablePython) python3;

      # for zdb to get the rpath to libgcc_s, needed for pthread_cancel to work
      NIX_CFLAGS_LINK = "-lgcc_s";

      hardeningDisable = [ "fortify" "stackprotector" "pic" ];

      configureFlags = [
        "--with-config=${configFile}"
        "--with-tirpc=1"
        (withFeatureAs (buildUser && enablePython) "python" python3.interpreter)
      ] ++ optionals buildUser [
        "--with-dracutdir=$(out)/lib/dracut"
        "--with-udevdir=$(out)/lib/udev"
        "--with-systemdunitdir=$(out)/etc/systemd/system"
        "--with-systemdpresetdir=$(out)/etc/systemd/system-preset"
        "--with-systemdgeneratordir=$(out)/lib/systemd/system-generator"
        "--with-mounthelperdir=$(out)/bin"
        "--libexecdir=$(out)/libexec"
        "--sysconfdir=/etc"
        "--localstatedir=/var"
        "--enable-systemd"
      ] ++ optionals buildKernel ([
        "--with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
        "--with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      ] ++ kernel.makeFlags);

      makeFlags = optionals buildKernel kernel.makeFlags;

      enableParallelBuilding = true;

      installFlags = [
        "sysconfdir=\${out}/etc"
        "DEFAULT_INITCONF_DIR=\${out}/default"
        "INSTALL_MOD_PATH=\${out}"
      ];

      postInstall = optionalString buildKernel ''
        # Add reference that cannot be detected due to compressed kernel module
        mkdir -p "$out/nix-support"
        echo "${util-linux}" >> "$out/nix-support/extra-refs"
      '' + optionalString buildUser ''
        # Remove provided services as they are buggy
        rm $out/etc/systemd/system/zfs-import-*.service

        sed -i '/zfs-import-scan.service/d' $out/etc/systemd/system/*

        for i in $out/etc/systemd/system/*; do
        substituteInPlace $i --replace "zfs-import-cache.service" "zfs-import.target"
        done

        # Remove tests because they add a runtime dependency on gcc
        rm -rf $out/share/zfs/zfs-tests

        # Add Bash completions.
        install -v -m444 -D -t $out/share/bash-completion/completions contrib/bash_completion.d/zfs
        (cd $out/share/bash-completion/completions; ln -s zfs zpool)
      '';

      postFixup = let
        path = "PATH=${makeBinPath [ coreutils gawk gnused gnugrep util-linux smartmon sysstat ]}:$PATH";
      in ''
        for i in $out/libexec/zfs/zpool.d/*; do
          sed -i '2i${path}' $i
        done
      '';

      outputs = [ "out" ] ++ optionals buildUser [ "dev" ];

      passthru = {
        inherit enableMail;

        tests =
          if isUnstable then [
            nixosTests.zfs.unstable
          ] else [
            nixosTests.zfs.installer
            nixosTests.zfs.stable
          ];
      };

      meta = {
        description = "ZFS Filesystem Linux Kernel module";
        longDescription = ''
          ZFS is a filesystem that combines a logical volume manager with a
          Copy-On-Write filesystem with data integrity detection and repair,
          snapshotting, cloning, block devices, deduplication, and more.
        '';
        homepage = "https://github.com/openzfs/zfs";
        license = licenses.cddl;
        platforms = platforms.linux;
        maintainers = with maintainers; [ hmenke jcumming jonringer wizeman fpletz globin mic92 ];
        broken = if
          buildKernel && (kernelCompatible != null) && !kernelCompatible
          then builtins.trace ''
            Linux v${kernel.version} is not yet supported by zfsonlinux v${version}.
            ${lib.optionalString (!isUnstable) "Try zfsUnstable or set the NixOS option boot.zfs.enableUnstable."}
          '' true
          else false;
      };
    };
in {
  # also check if kernel version constraints in
  # ./nixos/modules/tasks/filesystems/zfs.nix needs
  # to be adapted
  zfsStable = common {
    # check the release notes for compatible kernels
    kernelCompatible = kernel.kernelAtLeast "3.10" && kernel.kernelOlder "5.12";

    # this package should point to the latest release.
    version = "2.0.4";

    sha256 = "sha256-ySTt0K3Lc0Le35XTwjiM5l+nIf9co7wBn+Oma1r8YHo=";
  };

  zfsUnstable = common {
    # check the release notes for compatible kernels
    kernelCompatible = kernel.kernelAtLeast "3.10" && kernel.kernelOlder "5.12";

    # this package should point to a version / git revision compatible with the latest kernel release
    version = "2.1.0-rc4";

    sha256 = "sha256-eakOEA7LCJOYDsZH24Y5JbEd2wh1KfCN+qX3QxQZ4e8=";

    isUnstable = true;
  };
}
