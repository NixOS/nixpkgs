{ runCommand, nettools, bc, perl, gmp, libmpc, mpfr, kmod, openssl
, writeTextFile, ubootTools
, hostPlatform
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
  # Any patches
  kernelPatches ? [],
  # Patches for native compiling only
  nativeKernelPatches ? [],
  # Patches for cross compiling only
  crossKernelPatches ? [],
  # The native kernel .config file
  configfile,
  # The cross kernel .config file
  crossConfigfile ? configfile,
  # Manually specified nixexpr representing the config
  # If unspecified, this will be autodetected from the .config
  config ? stdenv.lib.optionalAttrs allowImportFromDerivation (readConfig configfile),
  # Cross-compiling config
  crossConfig ? if allowImportFromDerivation then (readConfig crossConfigfile) else config,
  # Whether to utilize the controversial import-from-derivation feature to parse the config
  allowImportFromDerivation ? false
}:

let
  inherit (stdenv.lib)
    hasAttr getAttr optional optionalString optionalAttrs maintainers platforms;

  installkernel = writeTextFile { name = "installkernel"; executable=true; text = ''
    #!${stdenv.shell} -e
    mkdir -p $4
    cp -av $2 $4
    cp -av $3 $4
  ''; };

  commonMakeFlags = [
    "O=$(buildRoot)"
  ] ++ stdenv.lib.optionals (stdenv.platform ? kernelMakeFlags)
    stdenv.platform.kernelMakeFlags;

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
        (isModular || (config.isDisabled "FIRMWARE_IN_KERNEL"));
    in (optionalAttrs isModular { outputs = [ "out" "dev" ]; }) // {
      passthru = {
        inherit version modDirVersion config kernelPatches configfile;
      };

      inherit src;

      preUnpack = ''
        mkdir build
        export buildRoot="$(pwd)/build"
      '';

      patches = map (p: p.patch) kernelPatches;

      prePatch = ''
        for mf in $(find -name Makefile -o -name Makefile.include -o -name install.sh); do
            echo "stripping FHS paths in \`$mf'..."
            sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g ; s|/sbin/||g'
        done
        sed -i Makefile -e 's|= depmod|= ${kmod}/bin/depmod|'
      '';

      configurePhase = ''
        runHook preConfigure
        ln -sv ${configfile} $buildRoot/.config
        make $makeFlags "''${makeFlagsArray[@]}" oldconfig
        runHook postConfigure

        make $makeFlags prepare
        actualModDirVersion="$(cat $buildRoot/include/config/kernel.release)"
        if [ "$actualModDirVersion" != "${modDirVersion}" ]; then
          echo "Error: modDirVersion specified in the Nix expression is wrong, it should be: $actualModDirVersion"
          exit 1
        fi

        # Note: we can get rid of this once http://permalink.gmane.org/gmane.linux.kbuild.devel/13800 is merged.
        buildFlagsArray+=("KBUILD_BUILD_TIMESTAMP=$(date -u -d @$SOURCE_DATE_EPOCH)")
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
      installTargets = [ (if platform.kernelTarget == "uImage" then "uinstall" else
                          if platform.kernelTarget == "zImage" || platform.kernelTarget == "Image.gz" then "zinstall" else
                          "install") ];

      postInstall = ''
        mkdir -p $dev
        cp $buildRoot/vmlinux $dev/
      '' + (optionalString installsFirmware ''
        mkdir -p $out/lib/firmware
      '') + (if (platform ? kernelDTB && platform.kernelDTB) then ''
        make $makeFlags "''${makeFlagsArray[@]}" dtbs dtbs_install INSTALL_DTBS_PATH=$out/dtbs
      '' else "") + (if isModular then ''
        if [ -z "$dontStrip" ]; then
          installFlagsArray+=("INSTALL_MOD_STRIP=1")
        fi
        make modules_install $makeFlags "''${makeFlagsArray[@]}" \
          $installFlags "''${installFlagsArray[@]}"
        unlink $out/lib/modules/${modDirVersion}/build
        unlink $out/lib/modules/${modDirVersion}/source

        mkdir -p $dev/lib/modules/${modDirVersion}/build
        cp -dpR ../$sourceRoot $dev/lib/modules/${modDirVersion}/source
        cd $dev/lib/modules/${modDirVersion}/source

        cp $buildRoot/{.config,Module.symvers} $dev/lib/modules/${modDirVersion}/build
        make modules_prepare $makeFlags "''${makeFlagsArray[@]}" O=$dev/lib/modules/${modDirVersion}/build

        # !!! No documentation on how much of the source tree must be kept
        # If/when kernel builds fail due to missing files, you can add
        # them here. Note that we may see packages requiring headers
        # from drivers/ in the future; it adds 50M to keep all of its
        # headers on 3.10 though.

        chmod u+w -R ../source
        arch=`cd $dev/lib/modules/${modDirVersion}/build/arch; ls`

        # Remove unusued arches
        mv arch/$arch .
        rm -fR arch
        mkdir arch
        mv $arch arch

        # Remove all driver-specific code (50M of which is headers)
        rm -fR drivers

        # Keep all headers
        find .  -type f -name '*.h' -print0 | xargs -0 chmod u-w

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
        sed -i Makefile -e 's|= ${kmod}/bin/depmod|= depmod|'
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
            + stdenv.lib.concatStrings (stdenv.lib.intersperse ", " (map (x: x.name) kernelPatches))
            + ")");
        license = stdenv.lib.licenses.gpl2;
        homepage = https://www.kernel.org/;
        repositories.git = https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;
        maintainers = [
          maintainers.thoughtpolice
        ];
        platforms = platforms.linux;
      };
    };
in

stdenv.mkDerivation ((drvAttrs config stdenv.platform (kernelPatches ++ nativeKernelPatches) configfile) // {
  name = "linux-${version}";

  enableParallelBuilding = true;

  nativeBuildInputs = [ perl bc nettools openssl gmp libmpc mpfr ]
    ++ optional (stdenv.platform.kernelTarget == "uImage") ubootTools;

  hardeningDisable = [ "bindnow" "format" "fortify" "stackprotector" "pic" ];

  makeFlags = commonMakeFlags ++ [
    "ARCH=${stdenv.platform.kernelArch}"
  ];

  karch = stdenv.platform.kernelArch;

  crossAttrs = let cp = hostPlatform.platform; in
    (drvAttrs crossConfig cp (kernelPatches ++ crossKernelPatches) crossConfigfile) // {
      makeFlags = commonMakeFlags ++ [
        "ARCH=${cp.kernelArch}"
        "CROSS_COMPILE=$(crossConfig)-"
      ];

      karch = cp.kernelArch;

      nativeBuildInputs = optional (cp.kernelTarget == "uImage") ubootTools;
  };
})
