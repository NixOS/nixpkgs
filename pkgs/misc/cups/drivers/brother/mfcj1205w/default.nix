{ stdenv
, fetchurl
, dpkg
, makeWrapper
, coreutils
, ghostscript
, gnugrep
, gnused
, which
, perl
, lib
}:

let
  model = "mfcj1205w";
  version = "3.5.0-1";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105289/${model}pdrv-${version}.i386.deb";
    sha256 = "0qkpnc5ijhr0dfbm8xvpvj2mqizqr79hnr8qbjr7v36fkym8gdiy";
  };
  reldir = "opt/brother/Printers/${model}/";

in rec {
  driver = stdenv.mkDerivation rec {
    inherit src version;
    name = "${model}drv-${version}";

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      dir="$out/${reldir}"
      substituteInPlace $dir/lpd/filter_${model} \
        --replace /usr/bin/perl ${perl}/bin/perl \
        --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
      wrapProgram $dir/lpd/filter_${model} \
        --prefix PATH : ${lib.makeBinPath [
          coreutils ghostscript gnugrep gnused which
        ]}
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $dir/lpd/x86_64/brmfcj1205wfilter
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} driver";
      homepage = "https://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = [ lib.maintainers.saoriyuko ];
    };
  };

  cupswrapper = stdenv.mkDerivation rec {
    inherit version src;
    name = "${model}cupswrapper-${version}";

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      basedir=${driver}/${reldir}
      dir=$out/${reldir}
      substituteInPlace $dir/cupswrapper/brother_lpdwrapper_${model} \
        --replace /usr/bin/perl ${perl}/bin/perl \
        --replace "basedir =~" "basedir = \"$basedir\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
      wrapProgram $dir/cupswrapper/brother_lpdwrapper_${model} \
        --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep gnused ]}
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      ln $dir/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter
      ln $dir/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} CUPS wrapper driver";
      homepage = "https://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.gpl2;
      platforms = [ "x86_64-linux" ];
      maintainers = [ lib.maintainers.saoriyuko ];
    };
  };
}
