{ pkgsi686Linux
, stdenv
, a2ps
, coreutils
, dpkg
, fetchurl
, file
, ghostscript
, gnugrep
, gnused
, lib
, makeWrapper
, perl
, psutils
, which
}:

let
  model = "mfc6490cw";
  version = "1.1.2-2";
  reldir = "usr/local/Brother/Printer/${model}";
  filterFile = "lpd/filter${model}";

in rec {
  driver = pkgsi686Linux.stdenv.mkDerivation rec {
    inherit version;
    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf006180/${model}lpr-${version}.i386.deb";
      sha256 = "1p33aal3dv3r03v9nbafrzx2bhij34hrsg2d71kwm738a8n18vnj";
    };
    name = "${model}drv-${version}";

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      dir="$out/${reldir}"
      file="$dir/${filterFile}"
      echo "Substituting $file"
      substituteInPlace "$file" \
        --replace "BR_PRT_PATH=" "BR_PRT_PATH=\"$dir\" #"
      wrapProgram "$file" \
        --prefix PATH : ${stdenv.lib.makeBinPath [
          coreutils ghostscript gnugrep gnused which a2ps file psutils
        ]}
      # need to use i686 glibc here, these are 32bit proprietary binaries
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $dir/lpd/br${model}filter
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} driver";
      homepage = http://www.brother.com/;
      license = stdenv.lib.licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ stdenv.lib.maintainers.syd ];
    };
  };

  cupswrapper = stdenv.mkDerivation rec {
    inherit version;
    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf006182/${model}cupswrapper-${version}.i386.deb";
      sha256 = "sha256:1msj1hz7i1jn806gkd4nahwdc4rff030fzp37pfdxg9hjc88vfxi";
    };
    name = "${model}cupswrapper-${version}";

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    # In this package we produce two files:
    # - A ppd file
    # - A cups wrapper
    # Both of them are contained in a single file called cupswrapper${model}
    # using HEREDOCs
    # We get them out by running that file.
    # Note that we can chose the ppd filename, but the filename for the lpdwrapper comes from the contents
    # of the ppd file.
    installPhase = ''
      basedir=${driver}/${reldir}
      dir=$out/${reldir}
      file=$dir/cupswrapper/cupswrapper${model}
      echo "Substituting $file"
      mkdir -p $out/share/cups/model
      mkdir -p $out/lib/cups/filter
      substituteInPlace $file \
        --replace '/usr/local/Brother/''${device_model}/''${printer_model}/lpd/filter''${printer_model}' "$basedir/${filterFile}" \
        --replace /usr/share/cups/model "$out/share/cups/model" \
        --replace /usr/share/ppd "$out/share/ppd" \
        --replace /usr/lib/cups/filter "$out/lib/cups/filter" \
        --replace /usr/lib64/cups/filter "$out/lib64/cups/filter" \
        --replace /usr/lib/cups/backend "$out/lib/cups/backend" \
        --replace /usr/lib64/cups/backend "$out/lib64/cups/backend" \
        --replace '/usr/local/Brother/''${device_model}/''${printer_model}' "$dir" \
        --replace '/usr/bin/psnup' '${psutils}/bin/psnup'
      wrapProgram $file \
        --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused ghostscript]}
      echo "We expect something like \"lpinfo: not found\", this can be ignored."
      $file
      lpdwrapperfile="$out/lib/cups/filter/brlpdwrapper${model}"
      wrapProgram $lpdwrapperfile \
        --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused psutils ghostscript ]}
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} CUPS wrapper driver";
      homepage = http://www.brother.com/;
      license = stdenv.lib.licenses.gpl2;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ stdenv.lib.maintainers.syd ];
    };
  };
}
