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
  perl,
  gnugrep,
  which,
}:

let
  version = "3.2.0-1";
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101912/hll2340dlpr-${version}.i386.deb";
    sha256 = "c0ae98b49b462cd8fbef445550f2177ce9d8bf627c904e182daa8cbaf8781e50";
  };

  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101913/hll2340dcupswrapper-${version}.i386.deb";
    sha256 = "8aa24a6a825e3a4d5b51778cb46fe63032ec5a731ace22f9ef2b0ffcc2033cc9";
  };

in
stdenv.mkDerivation {
  pname = "cups-brother-hll2340dw";
  inherit version;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x ${cupsdeb} $out
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D \
      --replace /opt "$out/opt" \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/HLL2340D/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HLL2340D\"; #"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2340D/lpd/brprintconflsr3
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2340D/lpd/rawtobr3

    for f in \
      $out/opt/brother/Printers/HLL2340D/cupswrapper/brother_lpdwrapper_HLL2340D \
      $out/opt/brother/Printers/HLL2340D/cupswrapper/paperconfigml1 \
    ; do
      wrapProgram $f \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            ghostscript
            gnugrep
            gnused
          ]
        }
    done

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D $out/lib/cups/filter/brother_lpdwrapper_HLL2340D

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/HLL2340D/cupswrapper/brother-HLL2340D-cups-en.ppd $out/share/cups/model/

    wrapProgram $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D \
      --prefix PATH ":" ${
        lib.makeBinPath [
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

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother hl-l2340dw printer driver";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=es&prod=hll2340dw_us_eu_as&os=128&flang=English";
    maintainers = [ maintainers.qknight ];
  };
}
