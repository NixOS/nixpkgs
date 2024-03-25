let
  genericBuild =
  { pkgs, lib, stdenv, fetchFromGitHub, fetchpatch
  , autoreconfHook269, util-linux, nukeReferences, coreutils
  , perl
  , configFile ? "all"

  # Test dependencies
  , ksh
  , lvm2
  , gzip
  , e2fsprogs

  # Userspace dependencies
  , zlib, libuuid, python3, attr, openssl
  , libtirpc
  , nfs-utils, samba
  , gawk, gnugrep, gnused, systemd
  , smartmontools, enableMail ? false
  , sysstat, pkg-config
  , curl
  , pam

  # Kernel dependencies
  , kernel ? null
  , enablePython ? true
  , ...
  }@outerArgs:

  assert (configFile == "kernel") -> (kernel != null);
  { version
  , hash
  , kernelModuleAttribute
  , extraPatches ? []
  , rev ? "zfs-${version}"
  , isUnstable ? false
  , latestCompatibleLinuxPackages
  , kernelCompatible ? null
  , maintainers ? (with lib.maintainers; [ amarshall adamcstephens ])
  , tests
  }@innerArgs:

  let
    inherit (lib) any optionalString optionals optional makeBinPath versionAtLeast;

    smartmon = smartmontools.override { inherit enableMail; };

    buildKernel = any (n: n == configFile) [ "kernel" "all" ];
    buildUser = any (n: n == configFile) [ "user" "all" ];
    isAtLeast22Series = versionAtLeast version "2.2.0";

    # XXX: You always want to build kernel modules with the same stdenv as the
    # kernel was built with. However, since zfs can also be built for userspace we
    # need to correctly pick between the provided/default stdenv, and the one used
    # by the kernel.
    # If you don't do this your ZFS builds will fail on any non-standard (e.g.
    # clang-built) kernels.
    stdenv' = if kernel == null then stdenv else kernel.stdenv;
  in

  stdenv'.mkDerivation {
    name = "zfs-${configFile}-${version}${optionalString buildKernel "-${kernel.version}"}";
    pname = "zfs";
    inherit version;

    src = fetchFromGitHub {
      owner = "openzfs";
      repo = "zfs";
      inherit rev hash;
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
        # TODO(Mindavi): Is overriding with /run/current-system/sw/bin acceptable?
        substituteInPlace scripts/zfs-tests.sh \
          --replace '$STF_PATH/ksh' ${ksh}/bin/ksh \
          --replace 'LOSETUP=' 'LOSETUP=${util-linux}/bin/losetup #' \
          --replace 'export PATH=$STF_PATH' '#' \
          --replace 'DMSETUP=' 'DMSETUP=${lvm2}/bin/dmsetup #' \
          --replace '$STF_PATH/gzip' '${gzip}/bin/gzip' \
          --replace '$STF_PATH/gunzip' '${gzip}/bin/gunzip' \
          --replace '/sbin/fsck.ext4' '${e2fsprogs}/bin/fsck.ext4' \
          --replace '/sbin/mkfs.ext4' '${e2fsprogs}/bin/mkfs.ext4' \
          --replace '$STF_PATH/awk' '${gawk}/bin/awk' \
          --replace 'SYSTEM_DIRS="/usr/local/bin /usr/local/sbin"' 'SYSTEM_DIRS="/run/current-system/sw/bin"'
        substituteInPlace scripts/common.sh.in \
          --replace 'export ZTS_DIR=' 'export ZTS_DIR=${placeholder "zfs_tests"}/share/zfs #' \
          --replace 'export SCRIPT_DIR=' 'export SCRIPT_DIR=${placeholder "zfs_tests"}/share/zfs #' \
          --replace 'export ZDB=' 'export ZDB=${placeholder "out"}/bin/zdb #' \
          --replace 'export ZFS=' 'export ZFS=${placeholder "out"}/bin/zfs #' \
          --replace 'export ZPOOL=' 'export ZPOOL=${placeholder "out"}/bin/zpool #' \
          --replace 'export ZTEST=' 'export ZTEST=${placeholder "out"}/bin/ztest #' \
          --replace 'export ZFS_SH=' 'export ZFS_SH=${placeholder "zfs_tests"}/share/zfs/zfs.sh #'
        # Fix ksh paths in test suite.
        # patchShebangs doesn't work due to the scripts not being executable.
        # It doesn't seem logical to make them executable either.
        find -name "*.ksh" -exec sed -i 's,/bin/ksh,${ksh}/bin/ksh,' {} \;
        # Patching maybe required for more binaries
        # Maybe FHS environment would be better?

      substituteInPlace ./lib/libshare/os/linux/nfs.c --replace "/usr/sbin/exportfs" "${
        # We don't *need* python support, but we set it like this to minimize closure size:
        # If it's disabled by default, no need to enable it, even if we have python enabled
        # And if it's enabled by default, only change that if we explicitly disable python to remove python from the closure
        nfs-utils.override (old: { enablePython = old.enablePython or true && enablePython; })
      }/bin/exportfs"
      substituteInPlace ./lib/libshare/smb.h        --replace "/usr/bin/net"            "${samba}/bin/net"
      # Disable dynamic loading of libcurl
      substituteInPlace ./config/user-libfetch.m4   --replace "curl-config --built-shared" "true"
      substituteInPlace ./config/user-systemd.m4    --replace "/usr/lib/modules-load.d" "$out/etc/modules-load.d"
      substituteInPlace ./config/zfs-build.m4       --replace "\$sysconfdir/init.d"     "$out/etc/init.d" \
                                                    --replace "/etc/default"            "$out/etc/default"
      substituteInPlace ./contrib/initramfs/Makefile.am \
        --replace "/usr/share/initramfs-tools" "$out/usr/share/initramfs-tools"
    '' + optionalString isAtLeast22Series ''
      substituteInPlace ./udev/vdev_id \
        --replace "PATH=/bin:/sbin:/usr/bin:/usr/sbin" \
         "PATH=${makeBinPath [ coreutils gawk gnused gnugrep systemd ]}"
    '' + optionalString (!isAtLeast22Series) ''
      substituteInPlace ./etc/zfs/Makefile.am --replace "\$(sysconfdir)/zfs" "$out/etc/zfs"

      find ./contrib/initramfs -name Makefile.am -exec sed -i -e 's|/usr/share/initramfs-tools|'$out'/share/initramfs-tools|g' {} \;

      substituteInPlace ./cmd/vdev_id/vdev_id \
        --replace "PATH=/bin:/sbin:/usr/bin:/usr/sbin" \
        "PATH=${makeBinPath [ coreutils gawk gnused gnugrep systemd ]}"
    '' + ''
      substituteInPlace ./config/zfs-build.m4 \
        --replace "bashcompletiondir=/etc/bash_completion.d" \
          "bashcompletiondir=$out/share/bash-completion/completions"
    '';

    nativeBuildInputs = [ autoreconfHook269 nukeReferences ]
      ++ optionals buildKernel (kernel.moduleBuildDependencies ++ [ perl ])
      ++ optional buildUser pkg-config;
    buildInputs = optionals buildUser [ zlib libuuid attr libtirpc pam ]
      ++ optional buildUser openssl
      ++ optional buildUser curl
      ++ optional (buildUser && enablePython) python3;

    # for zdb to get the rpath to libgcc_s, needed for pthread_cancel to work
    NIX_CFLAGS_LINK = "-lgcc_s";

    hardeningDisable = [ "fortify" "stackprotector" "pic" ];

    configureFlags = [
      "--with-config=${configFile}"
      "--with-tirpc=1"
      (lib.withFeatureAs (buildUser && enablePython) "python" python3.interpreter)
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
      "--enable-pam"
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

    preConfigure = ''
      # The kernel module builds some tests during the configurePhase, this envvar controls their parallelism
      export TEST_JOBS=$NIX_BUILD_CORES
      if [ -z "$enableParallelBuilding" ]; then
        export TEST_JOBS=1
      fi
    '';

    # Enabling BTF causes zfs to be build with debug symbols.
    # Since zfs compress kernel modules on installation, our strip hooks skip stripping them.
    # Hence we strip modules prior to compression.
    postBuild = optionalString buildKernel ''
       find . -name "*.ko" -print0 | xargs -0 -P$NIX_BUILD_CORES ${stdenv.cc.targetPrefix}strip --strip-debug
    '';

    postInstall = optionalString buildKernel ''
      # Add reference that cannot be detected due to compressed kernel module
      mkdir -p "$out/nix-support"
      echo "${util-linux}" >> "$out/nix-support/extra-refs"
    '' + optionalString buildUser ''
      # Remove provided services as they are buggy
      rm $out/etc/systemd/system/zfs-import-*.service

      for i in $out/etc/systemd/system/*; do
         if [ -L $i ]; then
           continue
         fi
         sed -i '/zfs-import-scan.service/d' $i
         substituteInPlace $i --replace "zfs-import-cache.service" "zfs-import.target"
      done

      # Remove tests because they add a runtime dependency on gcc
      # TODO(mindavi): Should we optionally remove these? How does that work?
      mkdir -p ${placeholder "zfs_tests"}/share/zfs/
      mv ${placeholder "out"}/share/zfs/ ${placeholder "zfs_tests"}/share/

      # Add Bash completions.
      install -v -m444 -D -t ${placeholder "out"}/share/bash-completion/completions contrib/bash_completion.d/zfs
      (cd $out/share/bash-completion/completions; ln -s zfs zpool)
    '';

    postFixup = let
      path = "PATH=${makeBinPath [ coreutils gawk gnused gnugrep util-linux smartmon sysstat ]}:$PATH";
    in ''
      for i in $out/libexec/zfs/zpool.d/*; do
        sed -i '2i${path}' $i
      done
    '';

    outputs = [ "out" ] ++ optionals buildUser [ "dev" "zfs_tests" ];

    passthru = {
      inherit enableMail latestCompatibleLinuxPackages kernelModuleAttribute;
      # The corresponding userspace tools to this instantiation
      # of the ZFS package set.
      userspaceTools = genericBuild (outerArgs // {
        configFile = "user";
      }) innerArgs;

      inherit tests;
    };

    meta = {
      description = "ZFS Filesystem Linux" + (if buildUser then " Userspace Tools" else " Kernel Module");
      longDescription = ''
        ZFS is a filesystem that combines a logical volume manager with a
        Copy-On-Write filesystem with data integrity detection and repair,
        snapshotting, cloning, block devices, deduplication, and more.

        ${if buildUser then "This is the userspace tools package." else "This is the kernel module package."}
      '';
      homepage = "https://github.com/openzfs/zfs";
      changelog = "https://github.com/openzfs/zfs/releases/tag/zfs-${version}";
      license = lib.licenses.cddl;

      # The case-block for TARGET_CPU has branches for only some CPU families,
      # which prevents ZFS from building on any other platform.  Since the NixOS
      # `boot.zfs.enabled` property is `readOnly`, excluding platforms where ZFS
      # does not build is the only way to produce a NixOS installer on such
      # platforms.
      # https://github.com/openzfs/zfs/blob/6723d1110f6daf93be93db74d5ea9f6b64c9bce5/config/always-arch.m4#L12
      platforms =
        with lib.systems.inspect.patterns;
        map (p: p // isLinux) ([ isx86_32 isx86_64 isPower isAarch64 isSparc ] ++ isArmv7);

      inherit maintainers;
      mainProgram = "zfs";
      # If your Linux kernel version is not yet supported by zfs, try zfs_unstable.
      # On NixOS set the option `boot.zfs.package = pkgs.zfs_unstable`.
      broken = buildKernel && (kernelCompatible != null) && !kernelCompatible;
    };
  };
in
  genericBuild
