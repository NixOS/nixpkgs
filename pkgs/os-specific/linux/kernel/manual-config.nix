{ stdenv, runCommand, nettools, bc, perl, kmod, writeTextFile }:

with stdenv.lib;

let

  # Function to parse the config file into a nix expression
  readConfig = configFile:
    let
      configAttrs = import "${runCommand "config.nix" {} ''
        echo "{" > "$out"
        while IFS='=' read key val; do
          [ "x''${key#CONFIG_}" != "x$key" ] || continue
          no_firstquote="''${val#\"}";
          echo '  "'"$key"'" = "'"''${no_firstquote%\"}"'";' >> "$out"
        done < "${configFile}"
        echo "}" >> $out
      ''}";

      config = configAttrs // rec {
        attrName = attr: "CONFIG_" + attr;

        isSet = attr: hasAttr (attrName attr) config;

        getValue = attr: if isSet attr then getAttr (attrName attr) config else null;

        isYes = attr: (isSet attr) && ((getValue attr) == "y");

        isNo = attr: (isSet attr) && ((getValue attr) == "n");

        isModule = attr: (isSet attr) && ((getValue attr) == "m");

        isEnabled = attr: (isModule attr) || (isYes attr);

        isDisabled = attr: (!(isSet attr)) || (isNo attr);
      };
    in
      config;

in

{
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
  config ? optionalAttrs allowImportFromDerivation (readConfig configfile),
  # Whether to utilize the controversial import-from-derivation feature to parse the config
  allowImportFromDerivation ? false
}:

let
  installkernel = name: writeTextFile { name = "installkernel"; executable=true; text = ''
    #!/bin/sh
    mkdir $4
    cp -av $2 $4/${name}
    cp -av $3 $4
  '';};

  isModular = config.isYes "MODULES";

  installsFirmware = (config.isEnabled "FW_LOADER") &&
    (isModular || (config.isDisabled "FIRMWARE_IN_KERNEL"));

  commonMakeFlags = [
    "O=$(buildRoot)"
    "INSTALL_PATH=$(out)"
  ] ++ (optional isModular "INSTALL_MOD_PATH=$(out)")
  ++ optional installsFirmware "INSTALL_FW_PATH=$(out)/lib/firmware";

  sourceRoot = stdenv.mkDerivation {
    name = "linux-${version}-source";

    inherit src;

    patches = map (p: p.patch) kernelPatches;

    phases = [ "unpackPhase" "patchPhase" "installPhase" ]; 

    prePatch = ''
      for mf in $(find -name Makefile -o -name Makefile.include -o -name install.sh); do
          echo "stripping FHS paths in \`$mf'..."
          sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g ; s|/sbin/||g'
      done
      sed -i Makefile -e 's|= depmod|= ${kmod}/sbin/depmod|'
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

  nativeBuildInputs = [ perl bc nettools ];

  makeFlags = commonMakeFlags ++ [
   "INSTALLKERNEL=${installkernel stdenv.platform.kernelTarget}"
  ];

  crossAttrs = {
    makeFlags = commonMakeFlags ++ [
     "INSTALLKERNEL=${installkernel stdenv.cross.platform.kernelTarget}"
    ];
  };

  postInstall = optionalString installsFirmware ''
    mkdir -p $out/lib/firmware
  '' + (if isModular then ''
    make modules_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
    rm -f $out/lib/modules/${modDirVersion}/build
    mkdir -p $dev/lib/modules/${modDirVersion}
    mv $out/lib/modules/${modDirVersion}/source $dev/lib/modules/${modDirVersion}/source
    mv $buildRoot $dev/lib/modules/${modDirVersion}/build
  '' else optionalString installsFirmware ''
    make firmware_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
  '');

  postFixup = if isModular then ''
    if [ -z "$dontStrip" ]; then
        find $out -name "*.ko" -print0 | xargs -0 -r strip -S
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
    platforms = lib.platforms.linux;
  };
}
