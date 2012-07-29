{ stdenv, runCommand, nettools, perl, kmod }:

{ version, modDirVersion ? version, src, patches ? [], config }:

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

  features = readFeatures config;

  commonMakeFlags = [
    "O=../build"
  ];
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
        sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g'
    done
    sed -i -e 's|/sbin/depmod|${kmod}/sbin/depmod|' Makefile
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

  INSTALL_PATH = "$(out)";

  buildNativeInputs = [ perl nettools ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv -v ../build/System.map $out
    # !!! Assumes x86
    mv -v ../build/arch/x86/boot/bzImage $out
    mv -v ../build/vmlinux $out
    runHook postInstall
  '';

  makeFlags = commonMakeFlags;
} // optionalAttrs features.modular {
  makeFlags = commonMakeFlags ++ [
    "MODLIB=\"$(out)/lib/modules/${modDirVersion}\""
  ];

  INSTALL_MOD_STRIP = "1";

  postInstall = ''
    make modules_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
    rm -f $out/lib/modules/${modDirVersion}/{build,source}
    cd ..
    mv $sourceRoot $out/lib/modules/${modDirVersion}/source
    mv build $out/lib/modules/${modDirVersion}/build
  '';
})
