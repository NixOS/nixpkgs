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
  gawk,
}:

let
  version = "3.0.1-1";
  cupsdeb = fetchurl {
    url = "http://download.brother.com/welcome/dlf100421/hl1110cupswrapper-${version}.i386.deb";
    sha256 = "a87880f4ece764a724411b5b24d15d1b912f6ffc6ecbfd9fac4cd5eda13d2eb7";
  };
  srcdir = "hl1110cupswrapper-GPL_src-${version}";
  cupssrc = fetchurl {
    url = "http://download.brother.com/welcome/dlf100422/${srcdir}.tar.gz";
    sha256 = "be1dce6a4608cb253b0b382db30bf5885da46b010e8eb595b15c435e2487761c";
  };
  lprdeb = fetchurl {
    url = "http://download.brother.com/welcome/dlf100419/hl1110lpr-${version}.i386.deb";
    sha256 = "5af241782a0d500d7f47e06ea43d61127f4019b5b1c6e68b4c1cb4521a742c22";
  };
in
stdenv.mkDerivation {
  pname = "cups-brother-hl1110";
  inherit version;

  srcs = [
    lprdeb
    cupssrc
    cupsdeb
  ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];
  unpackPhase = ''
    tar -xvf ${cupssrc}
  '';
  buildPhase = ''
    gcc -Wall ${srcdir}/brcupsconfig/brcupsconfig.c -o brcupsconfig4
  '';
  installPhase = ''
    # install lpr
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/HL1110/lpd/filter_HL1110 \
    --replace /opt "$out/opt" \

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/HL1110/lpd/psconvert2

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/opt/brother/Printers/HL1110/lpd/brprintconflsr3
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/opt/brother/Printers/HL1110/lpd/rawtobr3
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/opt/brother/Printers/HL1110/inf/braddprinter

    wrapProgram $out/opt/brother/Printers/HL1110/lpd/psconvert2 \
    --prefix PATH ":" ${
      lib.makeBinPath [
        gnused
        coreutils
        gawk
      ]
    }

    wrapProgram $out/opt/brother/Printers/HL1110/lpd/filter_HL1110 \
    --prefix PATH ":" ${
      lib.makeBinPath [
        ghostscript
        a2ps
        file
        gnused
        coreutils
      ]
    }


    dpkg-deb -x ${cupsdeb} $out

    substituteInPlace $out/opt/brother/Printers/HL1110/cupswrapper/brother_lpdwrapper_HL1110 --replace /opt "$out/opt"

    mkdir -p $out/lib/cups/filter
    ln -s $out/opt/brother/Printers/HL1110/cupswrapper/brother_lpdwrapper_HL1110 $out/lib/cups/filter/brother_lpdwrapper_HL1110
    ln -s $out/opt/brother/Printers/HL1110/cupswrapper/brother-HL1110-cups-en.ppd $out/lib/cups/filter/brother-HL1110-cups-en.ppd
    cp brcupsconfig4 $out/opt/brother/Printers/HL1110/cupswrapper/
    ln -s $out/opt/brother/Printers/HL1110/cupswrapper/brcupsconfig4 $out/lib/cups/filter/brcupsconfig4

    wrapProgram $out/opt/brother/Printers/HL1110/cupswrapper/brother_lpdwrapper_HL1110 \
    --prefix PATH ":" ${
      lib.makeBinPath [
        gnused
        coreutils
        gawk
      ]
    }

  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother HL1110 printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "http://support.brother.com/g/b/downloadlist.aspx?c=eu_ot&lang=en&prod=hl1110_us_eu_as&os=128#SelectLanguageType-561_0_1";
  };
}
