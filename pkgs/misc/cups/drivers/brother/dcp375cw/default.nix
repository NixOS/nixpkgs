{
  lib,
  stdenv,
  fetchurl,
  cups,
  dpkg,
  gnused,
  makeWrapper,
  ghostscript,
  file,
  a2ps,
  coreutils,
  gnugrep,
  which,
  gawk,
}:

let
  version = "1.1.3";
  model = "dcp375cw";
in
{
  driver = stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf005427/dcp375cwlpr-${version}-1.i386.deb";
      hash = "sha256-ba8BRLWALqjaOUyhTbDm8CANQElUVkkoN5H4mbf3vSY=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];
    buildInputs = [
      cups
      ghostscript
      a2ps
      gawk
    ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
      --replace /opt "$out/opt"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brlpdwrapper${model}

      wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --prefix PATH ":" ${
          lib.makeBinPath [
            gawk
            ghostscript
            a2ps
            file
            gnused
            gnugrep
            coreutils
            which
          ]
        }
    '';

    meta = {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer driver";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_all&os=128";
      maintainers = with lib.maintainers; [ marcovergueira ];
    };
  };

  cupswrapper = stdenv.mkDerivation {
    pname = "${model}-cupswrapper";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf005429/dcp375cwcupswrapper-${version}-1.i386.deb";
      hash = "sha256-miVXKLWV0mZ7LK+dDTMrZ34aaCmj7B7W1OkApEBpzy0=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
    ];
    buildInputs = [
      cups
      ghostscript
      a2ps
      gawk
    ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
        wrapProgram $f --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            ghostscript
            gnugrep
            gnused
          ]
        }
      done

      mkdir -p $out/share/cups/model
      ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
    '';

    meta = {
      homepage = "http://www.brother.com/";
      description = "Brother ${model} printer CUPS wrapper driver";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_all&os=128";
      maintainers = with lib.maintainers; [ marcovergueira ];
    };
  };
}
