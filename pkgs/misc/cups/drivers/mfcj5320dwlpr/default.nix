{ lib, stdenv, fetchurl, pkgsi686Linux, dpkg, makeWrapper, coreutils, gnused, gawk, file, cups, util-linux, xxd, runtimeShell
, ghostscript, a2ps }:

stdenv.mkDerivation rec {
  pname = "mfcj5320dwlpr";
  version = "3.0.1-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101591/${pname}-${version}.i386.deb";
    sha256 = "YoifiwyKen0BJBMXvuTcCP6sG+lII3ibea2/Fs5DqJA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  dontUnpack = true;

  brprintconf_mfcj5320dw_script = ''
    #!${runtimeShell}
    cd $(mktemp -d)
    ln -s @out@/usr/bin/brprintconf_mfcj5320dw_patched brprintconf_mfcj5320dw_patched
    ln -s @out@/opt/brother/Printers/mfcj5320dw/inf/brmfcj5320dwfunc brmfcj5320dwfunc
    ln -s @out@/opt/brother/Printers/mfcj5320dw/inf/brmfcj5320dwrc brmfcj5320dwrc
    ./brprintconf_mfcj5320dw_patched "$@"
  '';

  installPhase = ''
    dpkg-deb -x $src $out
    substituteInPlace $out/opt/brother/Printers/mfcj5320dw/lpd/filtermfcj5320dw \
      --replace /opt "$out/opt"
    substituteInPlace $out/opt/brother/Printers/mfcj5320dw/lpd/psconvertij2 \
      --replace "GHOST_SCRIPT=`which gs`" "GHOST_SCRIPT=${ghostscript}/bin/gs"
    substituteInPlace $out/opt/brother/Printers/mfcj5320dw/inf/setupPrintcapij \
      --replace "/opt/brother/Printers" "$out/opt/brother/Printers" \
      --replace "printcap.local" "printcap"

    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 \
      --set-rpath $out/opt/brother/Printers/mfcj5320dw/inf:$out/opt/brother/Printers/mfcj5320dw/lpd \
      $out/opt/brother/Printers/mfcj5320dw/lpd/brmfcj5320dwfilter
    patchelf --set-interpreter ${pkgsi686Linux.stdenv.cc.libc.out}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_mfcj5320dw

    #stripping the hardcoded path.
    ${util-linux}/bin/hexdump -ve '1/1 "%.2X"' $out/usr/bin/brprintconf_mfcj5320dw | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F6272257366756E63.62726d66636a36353130647766756e63000000000000000000000000000000000000000000.' | \
    sed 's.2F6F70742F62726F746865722F5072696E746572732F25732F696E662F627225737263.62726D66636A3635313064777263000000000000000000000000000000000000000000.' | \
    ${xxd}/bin/xxd -r -p > $out/usr/bin/brprintconf_mfcj5320dw_patched
    chmod +x $out/usr/bin/brprintconf_mfcj5320dw_patched
    #executing from current dir. segfaults if it's not r\w.
    mkdir -p $out/bin
    echo -n "$brprintconf_mfcj5320dw_script" > $out/bin/brprintconf_mfcj5320dw
    chmod +x $out/bin/brprintconf_mfcj5320dw
    substituteInPlace $out/bin/brprintconf_mfcj5320dw --replace @out@ $out

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj5320dw/lpd/filtermfcj5320dw $out/lib/cups/filter/brother_lpdwrapper_mfcj5320dw

    wrapProgram $out/opt/brother/Printers/mfcj5320dw/lpd/psconvertij2 \
      --prefix PATH ":" ${ lib.makeBinPath [ coreutils gnused gawk ] }
    wrapProgram $out/opt/brother/Printers/mfcj5320dw/lpd/filtermfcj5320dw \
      --prefix PATH ":" ${ lib.makeBinPath [ coreutils gnused file ghostscript a2ps ] }
    '';

  meta = with lib; {
    description = "Brother MFC-J5320DW LPR printer driver";
    homepage = "http://www.brother.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ martfont ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
