{ pkgs, lib, stdenv, fetchFromGitHub, fetchpatch
, autoreconfHook269, util-linux, nukeReferences, coreutils
, perl, nixosTests
, configFile ? "all"

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
}:

{ version
, sha256
, extraPatches ? []
, rev ? "zfs-${version}"
, isUnstable ? false
, latestCompatibleLinuxPackages
, kernelCompatible ? null
}:

let
  inherit (lib) any optionalString optionals optional makeBinPath;

  smartmon = smartmontools.override { inherit enableMail; };

  buildKernel = any (n: n == configFile) [ "kernel" "all" ];
  buildUser = any (n: n == configFile) [ "user" "all" ];

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

  src = fetchFromGitHub {
    owner = "openzfs";
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
    substituteInPlace ./lib/libshare/smb.h        --replace "/usr/bin/net"            "${samba}/bin/net"
    # Disable dynamic loading of libcurl
    substituteInPlace ./config/user-libfetch.m4   --replace "curl-config --built-shared" "true"
    substituteInPlace ./config/user-systemd.m4    --replace "/usr/lib/modules-load.d" "$out/etc/modules-load.d"
    substituteInPlace ./config/zfs-build.m4       --replace "\$sysconfdir/init.d"     "$out/etc/init.d" \
                                                  --replace "/etc/default"            "$out/etc/default"
    # TODO: drop when upgrading to 2.2.0
    ${if isUnstable then ''
      substituteInPlace ./contrib/initramfs/Makefile.am \
        --replace "/usr/share/initramfs-tools" "$out/usr/share/initramfs-tools"
      substituteInPlace ./udev/vdev_id \
        --replace "PATH=/bin:/sbin:/usr/bin:/usr/sbin" \
         "PATH=${makeBinPath [ coreutils gawk gnused gnugrep systemd ]}"
      substituteInPlace ./config/zfs-build.m4 \
        --replace "bashcompletiondir=/etc/bash_completion.d" \
          "bashcompletiondir=$out/share/bash-completion/completions"
    '' else ''
      substituteInPlace ./etc/zfs/Makefile.am --replace "\$(sysconfdir)/zfs" "$out/etc/zfs"

      find ./contrib/initramfs -name Makefile.am -exec sed -i -e 's|/usr/share/initramfs-tools|'$out'/share/initramfs-tools|g' {} \;

      substituteInPlace ./cmd/vdev_id/vdev_id \
        --replace "PATH=/bin:/sbin:/usr/bin:/usr/sbin" \
        "PATH=${makeBinPath [ coreutils gawk gnused gnugrep systemd ]}"
    ''}
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
    inherit enableMail latestCompatibleLinuxPackages;

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
    changelog = "https://github.com/openzfs/zfs/releases/tag/zfs-${version}";
    license = lib.licenses.cddl;

    # The case-block for TARGET_CPU has branches for only five CPU families,
    # which prevents ZFS from building on any other platform.  Since the NixOS
    # `boot.zfs.enabled` property is `readOnly`, excluding platforms where ZFS
    # does not build is the only way to produce a NixOS installer on such
    # platforms.
    # https://github.com/openzfs/zfs/blob/6a6bd493988c75331deab06e5352a9bed035a87d/config/always-arch.m4#L16
    platforms =
      with lib.systems.inspect.patterns;
      map (p: p // isLinux) [ isx86_32 isx86_64 isPower isAarch64 isSparc ];

    maintainers = with lib.maintainers; [ jcumming jonringer globin raitobezarius ];
    mainProgram = "zfs";
    # If your Linux kernel version is not yet supported by zfs, try zfsUnstable.
    # On NixOS set the option boot.zfs.enableUnstable.
    broken = buildKernel && (kernelCompatible != null) && !kernelCompatible;
  };
}

