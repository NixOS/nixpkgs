{
  lib,
  stdenv,
  pkgsi686Linux,
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
    url = "https://download.brother.com/welcome/dlf101546/hl1210wcupswrapper-${version}.i386.deb";
    sha256 = "0395mnw6c7qpjgjch9in5q9p2fjdqvz9bwfwp6q1hzhs08ryk7w0";
  };
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101547/hl1210wlpr-${version}.i386.deb";
    sha256 = "1sl3g2cd4a2gygryrr27ax3qaa65cbirz3kzskd8afkwqpmjyv7j";
  };
in
stdenv.mkDerivation {
  pname = "cups-brother-hl1210W";
  inherit version;

  srcs = [
    lprdeb
    cupsdeb
  ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];
  dontUnpack = true;

  installPhase = ''
    # install lpr
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/HL1210W/lpd/filter_HL1210W \
      --replace /opt "$out/opt"

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/HL1210W/lpd/psconvert2

    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/HL1210W/lpd/brprintconflsr3
    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/HL1210W/lpd/rawtobr3
    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/HL1210W/inf/braddprinter

    wrapProgram $out/opt/brother/Printers/HL1210W/lpd/psconvert2 \
      --prefix PATH ":" ${
        lib.makeBinPath [
          gnused
          coreutils
          gawk
        ]
      }
    wrapProgram $out/opt/brother/Printers/HL1210W/lpd/filter_HL1210W \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          a2ps
          file
          gnused
          coreutils
        ]
      }

    # install cups
    dpkg-deb -x ${cupsdeb} $out

    substituteInPlace $out/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W --replace /opt "$out/opt"

    mkdir -p $out/lib/cups/filter
    ln -s $out/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W $out/lib/cups/filter/brother_lpdwrapper_HL1210W
    ln -s $out/opt/brother/Printers/HL1210W/cupswrapper/brother-HL1210W-cups-en.ppd $out/lib/cups/filter/brother-HL1210W-cups-en.ppd
    # cp brcupsconfig4 $out/opt/brother/Printers/HL1110/cupswrapper/
    ln -s $out/opt/brother/Printers/HL1210W/cupswrapper/brcupsconfig4 $out/lib/cups/filter/brcupsconfig4

    wrapProgram $out/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W \
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
    description = "Brother HL1210W printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=nz&lang=en&prod=hl1210w_eu_as&os=128";
  };
}
