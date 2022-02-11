{lib, stdenv, fetchurl, cups, dpkg, gnused, makeWrapper, ghostscript, file, a2ps, coreutils, gawk}:

let
  version = "1.1.4-0";
  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf007070/hl3140cwcupswrapper-${version}.i386.deb";
    sha256 = "a76281828ca6ee86c63034673577fadcf5f24e8ed003213bdbb6bf47a7aced6f";
  };
  srcdir = "hl3140cw_cupswrapper_GPL_source_${version}";
  cupssrc = fetchurl {
    url = "https://download.brother.com/welcome/dlf006740/${srcdir}.tar.gz";
    sha256 = "1wp85rbvbar6rqqkaffymxjpls6jx9m9230dlrpqwy5akiaxf0rl";
  };
  lprdeb = fetchurl {
    url = "https://support.brother.com/g/b/files/dlf/dlf007068/hl3140cwlpr-1.1.2-1.i386.deb";
    sha256 = "601f392b52ed7080f71b780181823bb8f6abfd0591146b452ba1f23e21f9f865";
  };
in
stdenv.mkDerivation {
  pname = "cups-brother-hl3140cw";
  inherit version;
  nativeBuildInputs = [ makeWrapper dpkg ];
  buildInputs = [ cups ghostscript a2ps ];

  unpackPhase = ''
    tar -xvf ${cupssrc}
  '';

  buildPhase = ''
    gcc -Wall ${srcdir}/brcupsconfig/brcupsconfig.c -o brcupsconfpt1
  '';

  installPhase = ''
    # install lpr
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/hl3140cw/lpd/filterhl3140cw \
      --replace /opt "$out/opt"
    substituteInPlace $out/opt/brother/Printers/hl3140cw/inf/setupPrintcapij \
      --replace /opt "$out/opt"

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/hl3140cw/lpd/psconvertij2

    patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/hl3140cw/lpd/brhl3140cwfilter
    patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_hl3140cw

    wrapProgram $out/opt/brother/Printers/hl3140cw/lpd/psconvertij2 \
      --prefix PATH ":" ${ lib.makeBinPath [ gnused coreutils gawk ] }

    wrapProgram $out/opt/brother/Printers/hl3140cw/lpd/filterhl3140cw \
      --prefix PATH ":" ${ lib.makeBinPath [ ghostscript a2ps file gnused coreutils ] }


    dpkg-deb -x ${cupsdeb} $out

    substituteInPlace $out/opt/brother/Printers/hl3140cw/cupswrapper/cupswrapperhl3140cw \
      --replace /opt "$out/opt"

    mkdir -p $out/lib/cups/filter
    ln -s $out/opt/brother/Printers/hl3140cw/cupswrapper/cupswrapperhl3140cw $out/lib/cups/filter/cupswrapperhl3140cw

    ln -s $out/opt/brother/Printers/hl3140cw/cupswrapper/brother_hl3140cw_printer_en.ppd $out/lib/cups/filter/brother_hl3140cw_printer_en.ppd

    cp brcupsconfpt1 $out/opt/brother/Printers/hl3140cw/cupswrapper/
    ln -s $out/opt/brother/Printers/hl3140cw/cupswrapper/brcupsconfpt1 $out/lib/cups/filter/brcupsconfpt1
    ln -s $out/opt/brother/Printers/hl3140cw/lpd/filterhl3140cw $out/lib/cups/filter/brother_lpdwrapper_hl3140cw

    wrapProgram $out/opt/brother/Printers/hl3140cw/cupswrapper/cupswrapperhl3140cw \
      --prefix PATH ":" ${ lib.makeBinPath [ gnused coreutils gawk ] }
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother hl3140cw printer driver";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=eu_ot&lang=en&prod=hl3140cw_us_eu&os=128";
  };
}
