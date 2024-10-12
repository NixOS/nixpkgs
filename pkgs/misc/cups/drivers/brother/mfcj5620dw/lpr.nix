{ lib, stdenv, fetchurl, cups, dpkg, ghostscript, a2ps, coreutils, gnused, gawk
, file, util-linux, xxd, runtimeShell, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mfcj5620dw-lpr";
  version = "3.0.1-1";

  src = fetchurl {
    url =
      "https://download.brother.com/welcome/dlf101194/mfcj5620dwlpr-${version}.i386.deb";
    sha256 = "sha256-45q7Y5GX6kXtlBjOuUx/k3Jo+J3FIdRFxTUCouleDz0=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  dontUnpack = true;

  brprintconf_mfcj5620dw_script = ''
    #!${runtimeShell}
    cd $(mktemp -d)
    ln -s @out@/usr/bin/brprintconf_mfcj5620dw_patched brprintconf_mfcj5620dw_patched
    ln -s @out@/opt/brother/Printers/mfcj5620dw/inf/brmfcj5620dwfunc brmfcj5620dwfunc
    ln -s @out@/opt/brother/Printers/mfcj5620dw/inf/brmfcj5620dwrc brmfcj5620dwrc
    ./brprintconf_mfcj5620dw_patched "$@"
  '';

  brmfcj5620dwfilter_script = ''
    #!${runtimeShell}
    cd $(mktemp -d)
    ln -s @out@/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter_patched brmfc5620dwfilter_patched
    ln -s @out@/opt/brother/Printers/mfcj5620dw/inf/ImagingArea ImagingArea
    ln -s @out@/opt/brother/Printers/mfcj5620dw/inf/PaperDimension PaperDimension
    ./brmfc5620dwfilter_patched "$@"
  '';

  installPhase = ''
    dpkg-deb -x $src $out
    substituteInPlace $out/opt/brother/Printers/mfcj5620dw/lpd/filtermfcj5620dw \
      --replace /opt "$out/opt"
    substituteInPlace $out/opt/brother/Printers/mfcj5620dw/lpd/psconvertij2 \
      --replace "GHOST_SCRIPT=`which gs`" "GHOST_SCRIPT=${ghostscript}/bin/gs"
    substituteInPlace $out/opt/brother/Printers/mfcj5620dw/inf/setupPrintcapij \
      --replace "/opt/brother/Printers" "$out/opt/brother/Printers" \
      --replace "printcap.local" "printcap"

    patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux.so.2 \
      --set-rpath $out/opt/brother/Printers/mfcj5620dw/inf:$out/opt/brother/Printers/mfcj5620dw/lpd \
      $out/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter
    patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_mfcj5620dw

    #stripping the hardcoded path.
    ${util-linux}/bin/hexdump -ve '1/1 "%.2X"' $out/usr/bin/brprintconf_mfcj5620dw | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F6272257366756E6300.62726d66636a36353130647766756e6300000000000000000000000000000000000000000000.' | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F62722573726300.62726D66636A363531306477726300000000000000000000000000000000000000000000.' | \
    ${xxd}/bin/xxd -r -p > $out/usr/bin/brprintconf_mfcj5620dw_patched
    chmod +x $out/usr/bin/brprintconf_mfcj5620dw_patched
    #executing from current dir. segfaults if it's not r\w.
    mkdir -p $out/bin
    echo -n "$brprintconf_mfcj5620dw_script" > $out/bin/brprintconf_mfcj5620dw
    chmod +x $out/bin/brprintconf_mfcj5620dw
    substituteInPlace $out/bin/brprintconf_mfcj5620dw --replace @out@ $out

    ${util-linux}/bin/hexdump -ve '1/1 "%.2X"' $out/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F496D6167696E674172656100.496D6167696E6741726561000000000000000000000000000000000000000000000000000000000000.' | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F506170657244696D656E73696F6E00.506170657244696D656E73696F6E000000000000000000000000000000000000000000000000000000000000.' | \
    ${xxd}/bin/xxd -r -p > $out/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter_patched
    chmod +x $out/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter_patched
    #executing from current dir. segfaults if it's not r\w.
    echo -n "$brmfcj5620dwfilter_script" > $out/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter
    chmod +x $out/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter
    substituteInPlace $out/opt/brother/Printers/mfcj5620dw/lpd/brmfcj5620dwfilter --replace @out@ $out

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj5620dw/lpd/filtermfcj5620dw $out/lib/cups/filter/brother_lpdwrapper_mfcj5620dw

    wrapProgram $out/opt/brother/Printers/mfcj5620dw/lpd/psconvertij2 \
      --prefix PATH ":" ${lib.makeBinPath [ coreutils gnused gawk ]}
    wrapProgram $out/opt/brother/Printers/mfcj5620dw/lpd/filtermfcj5620dw \
      --prefix PATH ":" ${lib.makeBinPath [ coreutils gnused file ghostscript a2ps ]}
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-J5620DW LPR driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage =
      "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj5620dw_us_eu&os=128";
    maintainers = [ lib.maintainers.leifhelm ];
  };
}
