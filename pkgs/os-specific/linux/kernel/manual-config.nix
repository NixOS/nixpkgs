{ buildPackages, runCommand, nettools, bc, bison, flex, perl, rsync, gmp, libmpc, mpfr, openssl
, libelf
, utillinux
, writeTextFile
}:

let
  readConfig = configfile: import (runCommand "config.nix" {} ''
    echo "{" > "$out"
    while IFS='=' read key val; do
      [ "x''${key#CONFIG_}" != "x$key" ] || continue
      no_firstquote="''${val#\"}";
      echo '  "'"$key"'" = "'"''${no_firstquote%\"}"'";' >> "$out"
    done < "${configfile}"
    echo "}" >> $out
  '').outPath;
in {
  # Allow overriding stdenv on each buildLinux call
  stdenv,
  # The kernel version
  version,
  # The version of the kernel module directory
  modDirVersion ? version,
  # The kernel source (tarball, git checkout, etc.)
  src,
  # a list of { name=..., patch=..., extraConfig=...} patches
  kernelPatches ? [],
  # The kernel .config file
  configfile,
  # Manually specified nixexpr representing the config
  # If unspecified, this will be autodetected from the .config
  config ? stdenv.lib.optionalAttrs allowImportFromDerivation (readConfig configfile),
  # Use defaultMeta // extraMeta
  extraMeta ? {},
  # Whether to utilize the controversial import-from-derivation feature to parse the config
  allowImportFromDerivation ? false,
  # ignored
  features ? null,
}:

let
  inherit (stdenv.lib)
    hasAttr getAttr optional optionals optionalString optionalAttrs maintainers platforms;

  # Dependencies that are required to build kernel modules
  moduleBuildDependencies = optional (stdenv.lib.versionAtLeast version "4.14") libelf;

  installkernel = writeTextFile { name = "installkernel"; executable=true; text = ''
    #!${stdenv.shell} -e
    mkdir -p $4
    cp -av $2 $4
    cp -av $3 $4
  ''; };

  commonMakeFlags = [
    "O=$(buildRoot)"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.platform ? kernelMakeFlags)
    stdenv.hostPlatform.platform.kernelMakeFlags;

  drvAttrs = config_: platform: kernelPatches: configfile:
    let
      config = let attrName = attr: "CONFIG_" + attr; in {
        isSet = attr: hasAttr (attrName attr) config;

        getValue = attr: if config.isSet attr then getAttr (attrName attr) config else null;

        isYes = attr: (config.getValue attr) == "y";

        isNo = attr: (config.getValue attr) == "n";

        isModule = attr: (config.getValue attr) == "m";

        isEnabled = attr: (config.isModule attr) || (config.isYes attr);

        isDisabled = attr: (!(config.isSet attr)) || (config.isNo attr);
      } // config_;

      isModular = config.isYes "MODULES";

      installsFirmware = (config.isEnabled "FW_LOADER") &&
        (isModular || (config.isDisabled "FIRMWARE_IN_KERNEL")) &&
        (stdenv.lib.versionOlder version "4.14");
    in (optionalAttrs isModular { outputs = [ "out" "dev" ]; }) // {
      passthru = {
        inherit version modDirVersion config kernelPatches configfile
          moduleBuildDependencies stdenv;
      };

      inherit src;

      patches = map (p: p.patch) kernelPatches;

      prePatch = ''
        for mf in $(find -name Makefile -o -name Makefile.include -o -name install.sh); do
            echo "stripping FHS paths in \`$mf'..."
            sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g ; s|/sbin/||g'
        done
        sed -i Makefile -e 's|= depmod|= ${buildPackages.kmod}/bin/depmod|'
        sed -i scripts/ld-version.sh -e "s|/usr/bin/awk|${buildPackages.gawk}/bin/awk|"
      '';

      configurePhase = ''
        runHook preConfigure

        mkdir build
        export buildRoot="$(pwd)/build"

        echo "manual-config configurePhase buildRoot=$buildRoot pwd=$PWD"

        if [ -f "$buildRoot/.config" ]; then
          echo "Could not link $buildRoot/.config : file exists"
          exit 1
        fi
        ln -sv ${configfile} $buildRoot/.config

        # reads the existing .config file and prompts the user for options in
        # the current kernel source that are not found in the file.
        make $makeFlags "''${makeFlagsArray[@]}" oldconfig
        runHook postConfigure

        make $makeFlags "''${makeFlagsArray[@]}" prepare
        actualModDirVersion="$(cat $buildRoot/include/config/kernel.release)"
        if [ "$actualModDirVersion" != "${modDirVersion}" ]; then
          echo "Error: modDirVersion ${modDirVersion} specified in the Nix expression is wrong, it should be: $actualModDirVersion"
          exit 1
        fi

        # Note: we can get rid of this once http://permalink.gmane.org/gmane.linux.kbuild.devel/13800 is merged.
        buildFlagsArray+=("KBUILD_BUILD_TIMESTAMP=$(date -u -d @$SOURCE_DATE_EPOCH)")

        cd $buildRoot
      '';

      buildFlags = [
        "KBUILD_BUILD_VERSION=1-NixOS"
        platform.kernelTarget
        "vmlinux"  # for "perf" and things like that
      ] ++ optional isModular "modules";

      installFlags = [
        "INSTALLKERNEL=${installkernel}"
        "INSTALL_PATH=$(out)"
      ] ++ (optional isModular "INSTALL_MOD_PATH=$(out)")
      ++ optional installsFirmware "INSTALL_FW_PATH=$(out)/lib/firmware";

      # Some image types need special install targets (e.g. uImage is installed with make uinstall)
      installTargets = [ (
        if platform ? kernelInstallTarget then platform.kernelInstallTarget
        else if platform.kernelTarget == "uImage" then "uinstall"
        else if platform.kernelTarget == "zImage" || platform.kernelTarget == "Image.gz" then "zinstall"
        else "install"
      ) ];

      postInstall = (optionalString installsFirmware ''
        mkdir -p $out/lib/firmware
      '') + (if (platform ? kernelDTB && platform.kernelDTB) then ''
        make $makeFlags "''${makeFlagsArray[@]}" dtbs dtbs_install INSTALL_DTBS_PATH=$out/dtbs
      '' else "") + (if isModular then ''
        mkdir -p $dev
        cp vmlinux $dev/
        if [ -z "$dontStrip" ]; then
          installFlagsArray+=("INSTALL_MOD_STRIP=1")
        fi
        make modules_install $makeFlags "''${makeFlagsArray[@]}" \
          $installFlags "''${installFlagsArray[@]}"
        unlink $out/lib/modules/${modDirVersion}/build
        unlink $out/lib/modules/${modDirVersion}/source

        mkdir -p $dev/lib/modules/${modDirVersion}/{build,source}

        # To save space, exclude a bunch of unneeded stuff when copying.
        (cd .. && rsync --archive --prune-empty-dirs \
            --exclude='/build/' \
            --exclude='/Documentation/' \
            * $dev/lib/modules/${modDirVersion}/source/)

        cd $dev/lib/modules/${modDirVersion}/source

        cp $buildRoot/{.config,Module.symvers} $dev/lib/modules/${modDirVersion}/build
        make modules_prepare $makeFlags "''${makeFlagsArray[@]}" O=$dev/lib/modules/${modDirVersion}/build

        # Keep some extra files on some arches (powerpc, aarch64)
        for f in arch/powerpc/lib/crtsavres.o arch/arm64/kernel/ftrace-mod.o; do
          if [ -f "$buildRoot/$f" ]; then
            cp $buildRoot/$f $dev/lib/modules/${modDirVersion}/build/$f
          fi
        done

        # !!! No documentation on how much of the source tree must be kept
        # If/when kernel builds fail due to missing files, you can add
        # them here. Note that we may see packages requiring headers
        # from drivers/ in the future; it adds 50M to keep all of its
        # headers on 3.10 though.

        chmod u+w -R ..
        arch=$(cd $dev/lib/modules/${modDirVersion}/build/arch; ls)

        # Remove unused arches
        for d in $(cd arch/; ls); do
          if [ "$d" = "$arch" ]; then continue; fi
          if [ "$arch" = arm64 ] && [ "$d" = arm ]; then continue; fi
          rm -rf arch/$d
        done

        # Remove all driver-specific code (50M of which is headers)
        rm -fR drivers

        # Keep all headers
        find .  -type f -name '*.h' -print0 | xargs -0 chmod u-w

        # Keep linker scripts (they are required for out-of-tree modules on aarch64)
        find .  -type f -name '*.lds' -print0 | xargs -0 chmod u-w

        # Keep root and arch-specific Makefiles
        chmod u-w Makefile
        chmod u-w arch/$arch/Makefile*

        # Keep whole scripts dir
        chmod u-w -R scripts

        # Delete everything not kept
        find . -type f -perm -u=w -print0 | xargs -0 rm

        # Delete empty directories
        find -empty -type d -delete

        # Remove reference to kmod
        sed -i Makefile -e 's|= ${buildPackages.kmod}/bin/depmod|= depmod|'
      '' else optionalString installsFirmware ''
        make firmware_install $makeFlags "''${makeFlagsArray[@]}" \
          $installFlags "''${installFlagsArray[@]}"
      '');

      requiredSystemFeatures = [ "big-parallel" ];

      meta = {
        description =
          "The Linux kernel" +
          (if kernelPatches == [] then "" else
            " (with patches: "
            + stdenv.lib.concatStringsSep ", " (map (x: x.name) kernelPatches)
            + ")");
        license = stdenv.lib.licenses.gpl2;
        homepage = https://www.kernel.org/;
        repositories.git = https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;
        maintainers = [
          maintainers.thoughtpolice
        ];
        platforms = platforms.linux;
      } // extraMeta;
    };
in

assert stdenv.lib.versionAtLeast version "4.14" -> libelf != null;
assert stdenv.lib.versionAtLeast version "4.15" -> utillinux != null;
stdenv.mkDerivation ((drvAttrs config stdenv.hostPlatform.platform kernelPatches configfile) // {
  name = "linux-${version}";

  enableParallelBuilding = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl bc nettools openssl rsync gmp libmpc mpfr ]
      ++ optional (stdenv.hostPlatform.platform.kernelTarget == "uImage") buildPackages.ubootTools
      ++ optional (stdenv.lib.versionAtLeast version "4.14") libelf
      ++ optional (stdenv.lib.versionAtLeast version "4.15") utillinux
      ++ optionals (stdenv.lib.versionAtLeast version "4.16") [ bison flex ]
      ;

  hardeningDisable = [ "bindnow" "format" "fortify" "stackprotector" "pic" ];

  # Absolute paths for compilers avoid any PATH-clobbering issues.
  makeFlags = commonMakeFlags ++ [
    "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
    "ARCH=${stdenv.hostPlatform.platform.kernelArch}"
  ] ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  karch = stdenv.hostPlatform.platform.kernelArch;
})
