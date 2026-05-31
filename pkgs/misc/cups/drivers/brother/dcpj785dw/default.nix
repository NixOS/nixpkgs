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
  pkgsi686Linux,
}:

let
  version = "1.0.0_0";
  model = "dcpj785dw";
in
{
  driver = stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {

      url = "https://download.brother.com/welcome/dlf102774/${model}lpr-1.0.0-0.i386.deb";
      sha256 = "sha256-EXUN69YJEz1M0ADEF+0uZ+hdMgIiXChwtf+NzeFk7j0=";
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

      patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brother_lpdwrapper_${model}

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
        } \
        --set LD_PRELOAD ${pkgsi686Linux.libredirect}/lib/libredirect.so \
        --set NIX_REDIRECTS /opt/=$out/opt/
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
      url = "https://download.brother.com/welcome/dlf102775/${model}cupswrapper-1.0.0-0.i386.deb";
      sha256 = "sha256-JrYn9UlQr48HlETUmsNRq4oNPwtSiTFCsOuPMJ2kzSU=";
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
      maintainers = with lib.maintainers; [ lewo ];
    };
  };
}
