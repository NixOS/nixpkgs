{ stdenv, runCommand, nettools, bc, perl, kmod, writeTextFile, ubootChooser }:

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
  # The kernel version
  version,
  # The version of the kernel module directory
  modDirVersion ? version,
  # The kernel source (tarball, git checkout, etc.)
  src,
  # Any patches
  kernelPatches ? [],
  # The kernel .config file
  configfile,
  # Manually specified nixexpr representing the config
  # If unspecified, this will be autodetected from the .config
  config ? stdenv.lib.optionalAttrs allowImportFromDerivation (readConfig configfile),
  # Whether to utilize the controversial import-from-derivation feature to parse the config
  allowImportFromDerivation ? false
}:

let config_ = config; in

let
  inherit (stdenv.lib)
    hasAttr getAttr optionalAttrs optional optionalString maintainers platforms;

  config = let attrName = attr: "CONFIG_" + attr; in {
    isSet = attr: hasAttr (attrName attr) config;

    getValue = attr: if config.isSet attr then getAttr (attrName attr) config else null;

    isYes = attr: (config.getValue attr) == "y";

    isNo = attr: (config.getValue attr) == "n";

    isModule = attr: (config.getValue attr) == "m";

    isEnabled = attr: (config.isModule attr) || (config.isYes attr);

    isDisabled = attr: (!(config.isSet attr)) || (config.isNo attr);
  } // config_;

  installkernel = writeTextFile { name = "installkernel"; executable=true; text = ''
    #!${stdenv.shell} -e
    mkdir -p $4
    cp -av $2 $4
    cp -av $3 $4
  '';};

  isModular = config.isYes "MODULES";

  installsFirmware = (config.isEnabled "FW_LOADER") &&
    (isModular || (config.isDisabled "FIRMWARE_IN_KERNEL"));

  commonMakeFlags = [
    "O=$(buildRoot)"
  ];

  # Some image types need special install targets (e.g. uImage is installed with make uinstall)
  installTarget = target: [ (if target == "uImage" then "uinstall" else "install") ];

  sourceRoot = stdenv.mkDerivation {
    name = "linux-source-${version}";

    inherit src;

    patches = map (p: p.patch) kernelPatches;

    phases = [ "unpackPhase" "patchPhase" "installPhase" ]; 

    prePatch = ''
      for mf in $(find -name Makefile -o -name Makefile.include -o -name install.sh); do
          echo "stripping FHS paths in \`$mf'..."
          sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g ; s|/sbin/||g'
      done
      sed -i Makefile -e 's|= depmod|= ${kmod}/sbin/depmod|'
      # Patch kconfig to print "###" after every question so that
      # generate-config.pl from the generic builder can answer them.
      # This only affects oldaskconfig.
      sed -e '/fflush(stdout);/i\printf("###");' -i scripts/kconfig/conf.c
    '';

    installPhase = ''
      cd ..
      mv $sourceRoot $out
    '';
  };
in

stdenv.mkDerivation {
  name = "linux-${version}";

  enableParallelBuilding = true;

  outputs = if isModular then [ "out" "dev" ] else null;

  passthru = {
    inherit version modDirVersion config kernelPatches src;
  };

  inherit sourceRoot;

  unpackPhase = ''
    mkdir build
    export buildRoot="$(pwd)/build"
    cd ${sourceRoot}
  '';

  configurePhase = ''
    runHook preConfigure
    ln -sv ${configfile} $buildRoot/.config
    make $makeFlags "''${makeFlagsArray[@]}" oldconfig
    runHook postConfigure
  '';

  nativeBuildInputs = [ perl bc nettools ] ++ optional (stdenv.platform.uboot != null)
    (ubootChooser stdenv.platform.uboot);

  makeFlags = commonMakeFlags ++ [
    "ARCH=${stdenv.platform.kernelArch}"
  ];

  buildFlags = [ stdenv.platform.kernelTarget ] ++ optional isModular "modules";

  installFlags = [
    "INSTALLKERNEL=${installkernel}"
    "INSTALL_PATH=$(out)"
  ] ++ (optional isModular "INSTALL_MOD_PATH=$(out)")
  ++ optional installsFirmware "INSTALL_FW_PATH=$(out)/lib/firmware";

  installTargets = installTarget stdenv.platform.kernelTarget;

  crossAttrs = let cp = stdenv.cross.platform; in {
    buildFlags = [ cp.kernelTarget ] ++ optional isModular "modules";

    makeFlags = commonMakeFlags ++ [
      "ARCH=${cp.kernelArch}"
      "CROSS_COMPILE=$(crossConfig)-"
    ];

    installTargets = installTarget cp.kernelTarget;

    buildInputs = optional (cp.uboot != null) (ubootChooser cp.uboot).crossDrv;
  };

  postInstall = optionalString installsFirmware ''
    mkdir -p $out/lib/firmware
  '' + (if isModular then ''
    make modules_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
    unlink $out/lib/modules/${modDirVersion}/build
    mkdir -p $dev/lib/modules/${modDirVersion}
    mv $out/lib/modules/${modDirVersion}/source $dev/lib/modules/${modDirVersion}/source
    mv $buildRoot $dev/lib/modules/${modDirVersion}/build
  '' else optionalString installsFirmware ''
    make firmware_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
  '');

  postFixup = if isModular then ''
    if [ -z "$dontStrip" ]; then
        find $out -name "*.ko" -print0 | xargs -0 -r ''${crossConfig+$crossConfig-}strip -S
        # Remove all references to the source directory to avoid unneeded
        # runtime dependencies
        find $out -name "*.ko" -print0 | xargs -0 -r sed -i \
          "s|${sourceRoot}|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${sourceRoot.name}|g"
    fi
  '' else null;

  meta = {
    description = "The Linux kernel";
    license = "GPLv2";
    homepage = http://www.kernel.org/;
    maintainers = [
      maintainers.shlevy
    ];
    platforms = platforms.linux;
  };
}
