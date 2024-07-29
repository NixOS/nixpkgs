{ lib
, stdenv
, fetchurl
, cups
, dpkg
, gnused
, makeWrapper
, ghostscript
, file
, a2ps
, coreutils
, gnugrep
, which
, gawk
}:

let
  version = "1.1.2";
  model = "dcp9020cdw";
in
rec {
  driver = stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf100441/dcp9020cdwlpr-${version}-1.i386.deb";
      sha256 = "1z6nma489s0a0b0a8wyg38yxanz4k99dg29fyjs4jlprsvmwk56y";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ cups ghostscript a2ps gawk ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
      --replace /opt "$out/opt"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brother_lpdwrapper_${model}

      wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --prefix PATH ":" ${lib.makeBinPath [
          gawk
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ]}
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer driver";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ pshirshov ];
    };
  };

  cupswrapper = stdenv.mkDerivation {
    pname = "${model}-cupswrapper";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf100443/dcp9020cdwcupswrapper-${version}-1.i386.deb";
      sha256 = "04yqm1qv9p4hgp1p6mqq4siygl4056s6flv6kqln8mvmcr8zaq1s";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ cups ghostscript a2ps gawk ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
        wrapProgram $f --prefix PATH : ${lib.makeBinPath [ coreutils ghostscript gnugrep gnused ]}
      done

      mkdir -p $out/share/cups/model
      ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
    '';

    meta = with lib; {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer CUPS wrapper driver";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ pshirshov ];
    };
  };
}
