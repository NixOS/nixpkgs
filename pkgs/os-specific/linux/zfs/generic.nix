let
  genericBuild =
    {
      lib,
      stdenv,
      fetchFromGitHub,
      autoreconfHook269,
      util-linux,
      nukeReferences,
      coreutils,
      linuxPackages,
      perl,
      udevCheckHook,
      configFile ? "all",

      # Userspace dependencies
      zlib,
      libuuid,
      python3,
      attr,
      openssl,
      libtirpc,
      nfs-utils,
      gawk,
      gnugrep,
      gnused,
      systemd,
      smartmontools,
      enableMail ? false,
      sysstat,
      pkg-config,
      curl,
      pam,
      nix-update-script,

      # Kernel dependencies
      kernel ? null,
      kernelModuleMakeFlags ? [ ],
      enablePython ? true,
      ...
    }@outerArgs:

    assert (configFile == "kernel") -> (kernel != null);
    {
      version,
      hash,
      kernelModuleAttribute,
      extraLongDescription ? "",
      extraPatches ? [ ],
      rev ? "zfs-${version}",
      kernelMinSupportedMajorMinor,
      kernelMaxSupportedMajorMinor,
      enableUnsupportedExperimentalKernel ? false, # allows building against unsupported Kernel versions
      maintainers ? (with lib.maintainers; [ amarshall ]),
      tests,
    }@innerArgs:

    let
      inherit (lib)
        elem
        optionalString
        optionals
        optional
        makeBinPath
        ;

      smartmon = smartmontools.override { inherit enableMail; };

      buildKernel = elem configFile [
        "kernel"
        "all"
      ];
      buildUser = elem configFile [
        "user"
        "all"
      ];
      kernelIsCompatible =
        kernel:
        let
          nextMajorMinor =
            ver:
            "${lib.versions.major ver}.${
              lib.pipe ver [
                lib.versions.minor
                lib.toInt
                (x: x + 1)
                toString
              ]
            }";
        in
        (lib.versionAtLeast kernel.version kernelMinSupportedMajorMinor)
        && (lib.versionOlder kernel.version (nextMajorMinor kernelMaxSupportedMajorMinor));

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

      postPatch =
        optionalString buildKernel ''
          patchShebangs scripts
          # The arrays must remain the same length, so we repeat a flag that is
          # already part of the command and therefore has no effect.
          substituteInPlace ./module/os/linux/zfs/zfs_ctldir.c \
            --replace-fail '"/usr/bin/env", "umount"' '"${util-linux}/bin/umount", "-n"' \
            --replace-fail '"/usr/bin/env", "mount"'  '"${util-linux}/bin/mount", "-n"'
        ''
        + optionalString buildUser ''
          substituteInPlace ./lib/libshare/os/linux/nfs.c --replace-fail "/usr/sbin/exportfs" "${
            # We don't *need* python support, but we set it like this to minimize closure size:
            # If it's disabled by default, no need to enable it, even if we have python enabled
            # And if it's enabled by default, only change that if we explicitly disable python to remove python from the closure
            nfs-utils.override (old: {
              enablePython = old.enablePython or true && enablePython;
            })
          }/bin/exportfs"
          substituteInPlace ./lib/libshare/smb.h        --replace-fail "/usr/bin/net"            "/run/current-system/sw/bin/net"
          # Disable dynamic loading of libcurl
          substituteInPlace ./config/user-libfetch.m4   --replace-fail "curl-config --built-shared" "true"
          substituteInPlace ./config/user-systemd.m4    --replace-fail "/usr/lib/modules-load.d" "$out/etc/modules-load.d"
          substituteInPlace ./config/zfs-build.m4       --replace-fail "\$sysconfdir/init.d"     "$out/etc/init.d" \
                                                        --replace-fail "/etc/default"            "$out/etc/default"
          substituteInPlace ./contrib/initramfs/Makefile.am \
            --replace-fail "/usr/share/initramfs-tools" "$out/usr/share/initramfs-tools"

          substituteInPlace ./udev/vdev_id \
            --replace-fail "PATH=/bin:/sbin:/usr/bin:/usr/sbin" \
             "PATH=${
               makeBinPath [
                 coreutils
                 gawk
                 gnused
                 gnugrep
                 systemd
               ]
             }"

          # substitute path that ZFS will pass on when calling external helper scripts (/etc/zfs/zpool.d/*, zfs_prepare_disk)
          substituteInPlace ./lib/libzfs/libzfs_util.c \
            --replace-fail \"PATH=/bin:/sbin:/usr/bin:/usr/sbin\" \
            \"PATH=/run/wrappers/bin:/run/current-system/sw/bin:/run/current-system/sw/sbin\"

          substituteInPlace ./config/zfs-build.m4 \
            --replace-fail "bashcompletiondir=/etc/bash_completion.d" \
              "bashcompletiondir=$out/share/bash-completion/completions"
        ''
        + lib.optionalString (lib.versionOlder version "2.4.0") ''
          substituteInPlace ./cmd/arc_summary --replace-fail "/sbin/modinfo" "modinfo"
        ''
        + lib.optionalString (lib.versionAtLeast version "2.4.0") ''
          substituteInPlace ./cmd/zarcsummary --replace-fail "/sbin/modinfo" "modinfo"
        ''
        + ''
          echo 'Supported Kernel versions:'
          grep '^Linux-' META
          echo 'Checking kernelMinSupportedMajorMinor is correct...'
          grep --quiet '^Linux-Minimum: *${lib.escapeRegex kernelMinSupportedMajorMinor}$' META
          echo 'Checking kernelMaxSupportedMajorMinor is correct...'
          grep --quiet '^Linux-Maximum: *${lib.escapeRegex kernelMaxSupportedMajorMinor}$' META
        '';

      nativeBuildInputs = [
        autoreconfHook269
        nukeReferences
      ]
      ++ optionals buildKernel (kernel.moduleBuildDependencies ++ [ perl ])
      ++ optionals buildUser [
        pkg-config
        udevCheckHook
      ];
      buildInputs =
        optionals buildUser [
          zlib
          libuuid
          attr
          libtirpc
          pam
        ]
        ++ optional buildUser openssl
        ++ optional buildUser curl
        ++ optional (buildUser && enablePython) python3;

      # for zdb to get the rpath to libgcc_s, needed for pthread_cancel to work
      NIX_CFLAGS_LINK = "-lgcc_s";

      hardeningDisable = [
        "fortify"
        "stackprotector"
        "pic"
      ];

      configureFlags = [
        "--with-config=${configFile}"
        "--with-tirpc=1"
        (lib.withFeatureAs (buildUser && enablePython) "python" python3.interpreter)
      ]
      ++ optional enableUnsupportedExperimentalKernel "--enable-linux-experimental"
      ++ optionals buildUser [
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
      ]
      ++ optionals buildKernel (
        [
          "--with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
          "--with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        ]
        ++ map (f: "KERNEL_${f}") kernelModuleMakeFlags
      );

      enableParallelBuilding = true;

      doInstallCheck = true;

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

      postInstall =
        optionalString buildKernel ''
          # Add reference that cannot be detected due to compressed kernel module
          mkdir -p "$out/nix-support"
          echo "${util-linux}" >> "$out/nix-support/extra-refs"
        ''
        + optionalString buildUser ''
          # Remove provided services as they are buggy
          rm $out/etc/systemd/system/zfs-import-*.service

          for i in $out/etc/systemd/system/*; do
             if [ -L $i ]; then
               continue
             fi
             sed -i '/zfs-import-scan.service/d' $i
             substituteInPlace $i --replace-warn "zfs-import-cache.service" "zfs-import.target"
          done

          # Remove tests because they add a runtime dependency on gcc
          rm -rf $out/share/zfs/zfs-tests
        '';

      postFixup =
        let
          path = "PATH=${
            makeBinPath [
              coreutils
              gawk
              gnused
              gnugrep
              util-linux
              smartmon
              sysstat
            ]
          }:$PATH";
        in
        ''
          for i in $out/libexec/zfs/zpool.d/*; do
            sed -i '2i${path}' $i
          done
        '';

      outputs = [ "out" ] ++ optionals buildUser [ "dev" ];

      passthru = {
        inherit kernel;
        inherit enableMail kernelModuleAttribute;
        latestCompatibleLinuxPackages = lib.warn "zfs.latestCompatibleLinuxPackages is deprecated and is now pointing at the default kernel. If using the stable LTS kernel (default `linuxPackages` is not possible then you must explicitly pin a specific kernel release. For example, `boot.kernelPackages = pkgs.linuxPackages_6_6`. Please be aware that non-LTS kernels are likely to go EOL before ZFS supports the latest supported non-LTS release, requiring manual intervention." linuxPackages;

        # The corresponding userspace tools to this instantiation
        # of the ZFS package set.
        userspaceTools = genericBuild (
          outerArgs
          // {
            configFile = "user";
          }
        ) innerArgs;

        inherit tests;
      }
      // lib.optionalAttrs (kernelModuleAttribute != "zfs_unstable") {
        updateScript = nix-update-script {
          extraArgs = [
            "--version-regex=^zfs-(${lib.versions.major version}\\.${lib.versions.minor version}\\.[0-9]+)"
            "--override-filename=pkgs/os-specific/linux/zfs/${lib.versions.major version}_${lib.versions.minor version}.nix"
          ];
        };
      };

      meta = {
        description = "ZFS Filesystem Linux" + (if buildUser then " Userspace Tools" else " Kernel Module");
        longDescription = ''
          ZFS is a filesystem that combines a logical volume manager with a
          Copy-On-Write filesystem with data integrity detection and repair,
          snapshotting, cloning, block devices, deduplication, and more.

          ${
            if buildUser then "This is the userspace tools package." else "This is the kernel module package."
          }
        ''
        + extraLongDescription;
        homepage = "https://github.com/openzfs/zfs";
        changelog = "https://github.com/openzfs/zfs/releases/tag/zfs-${version}";
        license = lib.licenses.cddl;

        # The case-block for TARGET_CPU has branches for only some CPU families,
        # which prevents ZFS from building on any other platform.  Since the NixOS
        # `boot.zfs.enabled` property is `readOnly`, excluding platforms where ZFS
        # does not build is the only way to produce a NixOS installer on such
        # platforms.
        # https://github.com/openzfs/zfs/blob/077269bfeddf2d35eb20f98289ac9d017b4a32ff/lib/libspl/include/sys/isa_defs.h#L267-L270
        platforms =
          with lib.systems.inspect.patterns;
          map (p: p // isLinux) [
            isx86
            isAarch
            isPower
            isS390
            isSparc
            isMips
            isRiscV64
            isLoongArch64
          ];

        inherit maintainers;
        mainProgram = "zfs";
        broken = buildKernel && !((kernelIsCompatible kernel) || enableUnsupportedExperimentalKernel);
      };
    };
in
genericBuild
