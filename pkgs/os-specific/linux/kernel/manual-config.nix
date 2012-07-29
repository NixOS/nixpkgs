{ stdenv, runCommand, nettools, perl, kmod, writeTextFile }:

with stdenv.lib;

let

  # Function to parse the config file to get the features supported
  readFeatures = config:
    let
      # !!! Original causes recursion too deep, need to import from derivation
      # linesWithComments = splitString "\n" (builtins.readFile config);
      lines = import "${runCommand "lines.nix" {} ''
        echo "[" >> $out
        while read line; do
            if [ -n "$line" ] && [ "#" != ''${line:0:1} ]; then
                echo "'''" >> $out
                echo $(echo $line | sed "s/'''/''''/g")"'''" >> $out
            fi
        done < ${config} 
        echo "]" >> $out
      ''}";

      nvpairs = map (s: let split = splitString "=" s; fst = head split; in {
        name = substring (stringLength "CONFIG_") (stringLength fst) fst;
        value = head (tail split);
      }) lines;

      configAttrs = listToAttrs nvpairs;

      getValue = option:
        if hasAttr option configAttrs then getAttr option configAttrs else null;

      isYes = option: (getValue option) == "y";
    in

    {
      modular = isYes "MODULES";
    };

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
  config,
  # Manually specified features the kernel supports
  # If unspecified, this will be autodetected from the .config
  features ? readFeatures config
}:

let
  commonMakeFlags = [
    "O=../build"
    "INSTALL_PATH=$(out)"
    "INSTALLKERNEL=${installkernel}"
  ];

  installkernel = writeTextFile { name = "installkernel"; executable=true; text = ''
    #!/bin/sh
    mkdir $4
    mv -v $2 $4
    mv -v $3 $4
  '';};
in

stdenv.mkDerivation ({
  name = "linux-${version}";

  enableParallelBuilding = true;

  passthru = {
    inherit version modDirVersion features;
  };

  inherit patches src;

  prePatch = ''
    for mf in $(find -name Makefile -o -name Makefile.include); do
        echo "stripping FHS paths in \`$mf'..."
        sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g ; s|/sbin/||g'
    done
  '';

  configurePhase = ''
    runHook preConfigure
    mkdir ../build
    make $makeFlags "''${makeFlagsArray[@]}" mrproper
    ln -sv ${config} ../build/.config
    make $makeFlags "''${makeFlagsArray[@]}" oldconfig
    rm ../build/.config.old
    runHook postConfigure
  '';

  buildNativeInputs = [ perl nettools kmod ];

  makeFlags = commonMakeFlags;
} // optionalAttrs (features ? modular && features.modular) {
  makeFlags = commonMakeFlags ++ [
    "MODLIB=\"$(out)/lib/modules/${modDirVersion}\""
  ];

  postInstall = ''
    make modules_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
    rm -f $out/lib/modules/${modDirVersion}/{build,source}
    cd ..
    mv $sourceRoot $out/lib/modules/${modDirVersion}/source
    mv build $out/lib/modules/${modDirVersion}/build
    unlink $out/lib/modules/${modDirVersion}/build/source
    ln -sv $out/lib/modules/${modDirVersion}/{,build/}source
  '';

  postFixup = ''
    if [ -z "$dontStrip" ]; then
        find $out -name "*.ko" -print0 | xargs -0 strip -S
    fi
  '';
})
