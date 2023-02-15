{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, autoPatchelfHook
, coreutils
, ghostscript
, gnugrep
, gnused
, which
, perl
}:

let
  make = "brother";
  model = "hll6400dw";
  version = "3.5.1-1";

  modelUpper = lib.strings.toUpper model;
  modelDir = modelUpper;
  reldir = "opt/brother/Printers/${modelDir}";

  srcs = {
    driver = rec {
      # https://download.brother.com/welcome/dlf102432/hll6400dwlpr-3.5.1-1.i386.deb
      inherit model version reldir;
      suffix = "lpr";
      dlf = "dlf102432";
      url = "https://download.brother.com/welcome/${dlf}/${model}${suffix}-${version}.i386.deb";
      sha256 = "sha256-dWB0fQuvLPs8FJMR8J8L2uoMfXAo/4lukJ2SXTjRx2E=";
    };
    wrapper = rec {
      # https://download.brother.com/welcome/dlf102433/hll6400dwcupswrapper-3.5.1-1.i386.deb
      inherit model version reldir;
      suffix = "cupswrapper";
      dlf = "dlf102433";
      url = "https://download.brother.com/welcome/${dlf}/${model}${suffix}-${version}.i386.deb";
      sha256 = "sha256-qLgPvS630nm6Kcefr5nTGn2fYNUfivlXTZArS5OLb4k=";
    };
  };

  fixupPerlScripts = ''
    fixupPerlScripts() {
      local path=$1
      local basedir=$2
      local modelDir=$3
      shift 3
      for script in "$@"; do
        echo "fixupPerlScripts: fixing script: $script"
        sed -i '
            s|^my $basedir\s*=.*;$|my $basedir = "'$basedir'";|;
            s|^$basedir\s*=~.*;$||;
            s|^my $PRINTER\s*=.*;$|my $PRINTER = "'$modelDir'";|;
            s|^$PRINTER\s*=~.*;$||;
          ' $script
        wrapProgram $script \
          --prefix PATH : $path \
          --set LANG C
      done
    }
  '';

  platformDirMap = {
    "x86_64-linux" = "x86_64";
    "i686-linux" = "i686";
    "armv7l-linux" = "armv7l";
  };

  platformDir = platformDirMap.${stdenv.hostPlatform.system};
in

stdenv.mkDerivation rec {
  inherit version;
  pname = "${make}-${model}-${suffix}";
  inherit (srcs.wrapper) suffix;

  src = fetchurl {
    inherit (srcs.wrapper) url sha256;
  };

  inherit (driver) nativeBuildInputs buildInputs unpackPhase;

  runtimeDeps = [
    coreutils
    gnugrep
    gnused
  ];

  driver = stdenv.mkDerivation rec {
    inherit version;
    pname = "${make}-${model}-${suffix}";
    inherit (srcs.driver) suffix;

    src = fetchurl {
      inherit (srcs.driver) url sha256;
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
      autoPatchelfHook
    ];

    buildInputs = [
      perl
    ];

    runtimeDeps = [
      coreutils
      ghostscript
      gnugrep
      gnused
      which
    ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      dir=$out/${reldir}
      subdir=$dir/lpd
      basedir=$out/${reldir}

      ${fixupPerlScripts}

      fixupPerlScripts \
        ${lib.makeBinPath runtimeDeps} \
        $basedir \
        ${modelDir} \
        $subdir/*lpdfilter*

      chmod -R +x $subdir
      mv $subdir/${platformDir}/* $subdir
      rm -rf $subdir/{${builtins.concatStringsSep "," (builtins.attrValues platformDirMap)}}
    '';

    meta = with lib; {
      description = "Brother ${modelUpper} driver";
      longDescription = ''
        This driver works with the socket protocol,
        for example socket://192.168.0.150,
        but not with the IPP protocol.
      '';
      homepage = "http://www.brother.com/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = builtins.attrNames platformDirMap;
      maintainers = with maintainers; [ milahu ];
    };
  };

  installPhase = ''
    dir=$out/${reldir}
    subdir=$dir/${suffix}
    basedir=${driver}/${reldir}

    # this file is expected by the PPD file
    # *cupsFilter:    "application/vnd.cups-pdf 0 brother_lpdwrapper_HLL6400DW"
    mv $subdir/*lpdwrapper* $subdir/brother_lpdwrapper_${modelUpper}

    chmod +x $subdir/*lpdwrapper*
    chmod +x $subdir/*paperconfig* || true

    ${fixupPerlScripts}

    fixupPerlScripts \
      ${lib.makeBinPath runtimeDeps} \
      $basedir \
      ${modelDir} \
      $subdir/*lpdwrapper*

    echo patching the PPD file: $subdir/*.ppd
    # make the name consistent with other brother drivers
    # example:
    # - Brother HLL6400DW
    # + Brother HL-L6400DW
    sed -i -E 's/(Brother ${
        builtins.substring 0 2 (modelUpper)
      })(${
        builtins.substring 2 999 (modelUpper)
      })/\1-\2/g' $subdir/*.ppd

    mkdir -p $out/lib/cups/filter
    ln -s -v $subdir/*lpdwrapper* $out/lib/cups/filter

    mkdir -p $out/share/cups/model
    ln -s -v $subdir/*.ppd $out/share/cups/model
  '';

  meta = with lib; {
    description = "Brother ${modelUpper} CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ milahu ];
  };
}
