{ stdenv, runCommand, nettools, perl, kmod, writeTextFile }:

with stdenv.lib;

let

  # Function to parse the config file into a nix expression
  readConfig = configFile:
    let
      configAttrs = import "${runCommand "config.nix" {} ''
        (. ${configFile}
        echo "{"
        for var in `set`; do
            if [[ "$var" =~ ^CONFIG_ ]]; then
                IFS="="
                set -- $var
                echo "\"$1\" = \"''${*:2}\";"
            fi
        done
        echo "}") > $out
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
  patches ? [],
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
    mv -v $2 $4/${name}
    mv -v $3 $4
  '';};

  isModular = config.isYes "MODULES";

  installsFirmware = (config.isEnabled "FW_LOADER") &&
    (isModular || (config.isDisabled "FIRMWARE_IN_KERNEL"));

  commonMakeFlags = [
    "O=../build"
    "INSTALL_PATH=$(out)"
  ] ++ (optional isModular "MODLIB=$(out)/lib/modules/${modDirVersion}")
  ++ optional installsFirmware "INSTALL_FW_PATH=$(out)/lib/firmware";
in

stdenv.mkDerivation {
  name = "linux-${version}";

  enableParallelBuilding = true;

  passthru = {
    inherit version modDirVersion config;
  };

  inherit patches src;

  prePatch = ''
    for mf in $(find -name Makefile -o -name Makefile.include -o -name install.sh); do
        echo "stripping FHS paths in \`$mf'..."
        sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g ; s|/sbin/||g'
    done
  '';

  configurePhase = ''
    runHook preConfigure
    mkdir ../build
    make $makeFlags "''${makeFlagsArray[@]}" mrproper
    ln -sv ${configfile} ../build/.config
    make $makeFlags "''${makeFlagsArray[@]}" oldconfig
    rm ../build/.config.old
    runHook postConfigure
  '';

  buildNativeInputs = [ perl nettools ] ++ optional isModular kmod;

  makeFlags = commonMakeFlags ++ [
   "INSTALLKERNEL=${installkernel stdenv.platform.kernelTarget}"
  ];

  crossAttrs = {
    makeFlags = commonMakeFlags ++ [
     "INSTALLKERNEL=${installkernel stdenv.cross.platform.kernelTarget}"
    ];
  };

  postInstall = stdenv.lib.optionalString installsFirmware ''
    mkdir -p $out/lib/firmware
  '' + (if isModular then ''
    make modules_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
    rm -f $out/lib/modules/${modDirVersion}/{build,source}
    cd ..
    mv $sourceRoot $out/lib/modules/${modDirVersion}/source
    mv build $out/lib/modules/${modDirVersion}/build
    unlink $out/lib/modules/${modDirVersion}/build/source
    ln -sv $out/lib/modules/${modDirVersion}/{,build/}source
  '' else optionalString installsFirmware ''
    make firmware_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
  '');

  postFixup = optionalString isModular ''
    if [ -z "$dontStrip" ]; then
        find $out -name "*.ko" -print0 | xargs -0 strip -S
    fi
  '';

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
