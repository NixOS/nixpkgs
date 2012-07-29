{ stdenv, runCommand, nettools, perl }:

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

in

stdenv.mkDerivation ({
  name = "linux-${version}";

  enableParallelBuilding = true;

  passthru = {
    inherit version modDirVersion features;
  };

  inherit patches src;

  postPatch = ''
    for mf in $(find -name Makefile); do
        echo "stripping FHS paths in \`$mf'..."
        sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g'
    done
  '';

  configurePhase = ''
    runHook preConfigure
    ln -sv ${config} .config
    make oldconfig
    rm .config.old
    runHook postConfigure
  '';

  INSTALL_PATH = "$(out)";

  buildNativeInputs = [ perl nettools ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv -v System.map $out
    # !!! Assumes x86
    mv -v arch/x86/boot/bzImage $out
    mv -v vmlinux $out
    runHook postInstall
  '';
} // optionalAttrs features.modular {
  makeFlags = [ "MODLIB=\"$(out)/lib/modules/${modDirVersion}\"" ];

  INSTALL_MOD_STRIP = "1";

  postInstall = ''
    make modules_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
    rm -f $out/lib/modules/${modDirVersion}/{build,source}
    cd ..
    mv $sourceRoot $out/lib/modules/${modDirVersion}/build
    ln -sv $out/lib/modules/${modDirVersion}/{build,source}
  '';
})
