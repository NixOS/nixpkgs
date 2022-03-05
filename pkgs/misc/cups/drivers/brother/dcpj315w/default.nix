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
  version = "1.1.3";
  model = "dcpj315w";
in
rec {
  driver = stdenv.mkDerivation {
    pname = "${model}-lpr";
    inherit version;

    src = fetchurl {
      url= "https://download.brother.com/welcome/dlf005591/dcpj315wlpr-${version}-1.i386.deb";
      sha256 = "1myc6jrbkk6rbx1ynhac24l3hlkz7dmic557rz6q69fc54m69zmi";
    };

    nativeBuildInputs = [ dpkg makeWrapper ];
    buildInputs = [ cups ghostscript a2ps gawk ];
    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
      --replace /opt "$out/opt"
 
      substituteInPlace $out/opt/brother/Printers/${model}/inf/brdcpj315wrc \
      --replace "Letter" "A4"

      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/${model}/lpd/br${model}filter

      mkdir -p $out/lib/cups/filter/
      ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brlpdwrapper${model}

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
      license = licenses.unfree;
      platforms = platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=as_ot&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ jensac ];
    };
  };

  cupswrapper = stdenv.mkDerivation {
    pname = "${model}-cupswrapper";
    inherit version;

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf005593/dcpj315wcupswrapper-${version}-1.i386.deb";
      sha256 = "0xvcav8wzairdd35cw9wn0mcji9lzq8aqp6pfddizjcnnfnzwxxk";
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
      license = licenses.unfree;
      platforms = platforms.linux;
      downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=as_ot&lang=en&prod=${model}_eu&os=128";
      maintainers = with maintainers; [ jensac ];
    };
  };
}
