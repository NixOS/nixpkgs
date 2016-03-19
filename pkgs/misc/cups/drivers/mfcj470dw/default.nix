{ stdenv, fetchurl, cups, dpkg, ghostscript, patchelf, a2ps, coreutils, gnused, gawk, file }:

stdenv.mkDerivation rec {
  name = "mfcj470dw-cupswrapper-${version}";
  version = "3.0.0-1";

  srcs =
    [ (fetchurl {
        url = "http://download.brother.com/welcome/dlf006843/mfcj470dwlpr-${version}.i386.deb";
        sha256 = "7202dd895d38d50bb767080f2995ed350eed99bc2b7871452c3c915c8eefc30a";
      })
      (fetchurl {
        url = "http://download.brother.com/welcome/dlf006845/mfcj470dwcupswrapper-${version}.i386.deb";
        sha256 = "92af9024e821159eccd78a8925fc77fb92b4f247f2d2c824ca303004077076a7";
      })
    ];

    buildInputs = [ cups ghostscript dpkg a2ps ];

  unpackPhase = "true";

  installPhase = ''
    for s in $srcs; do dpkg-deb -x $s $out; done

    substituteInPlace $out/opt/brother/Printers/mfcj470dw/cupswrapper/cupswrappermfcj470dw \
      --replace /opt "$out/opt" \
      --replace /usr "$out/usr" \
      --replace /etc "$out/etc"

    substituteInPlace $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw \
      --replace /opt "$out/opt" \
      --replace file "${file}/bin/file" \
      --replace sed "${gnused}/bin/sed" \
      --replace mktemp "${coreutils}/bin/mktemp" \
      --replace cat "${coreutils}/bin/cat" \
      --replace rm "${coreutils}/bin/rm"

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/mfcj470dw/lpd/psconvertij2
    substituteInPlace $out/opt/brother/Printers/mfcj470dw/lpd/psconvertij2 \
      --replace awk "${gawk}/bin/awk" \
      --replace cat "${coreutils}/bin/cat" \
      --replace mktemp "${coreutils}/bin/mktemp" \
      --replace sed "${gnused}/bin/sed" \
      --replace expr "${coreutils}/bin/expr" \
      --replace rm "${coreutils}/bin/rm"

    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/opt/brother/Printers/mfcj470dw/lpd/brmfcj470dwfilter
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/opt/brother/Printers/mfcj470dw/cupswrapper/brcupsconfpt1

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw $out/lib/cups/filter/brother_lpdwrapper_mfcj470dw
  '';

  meta = {
    homepage = http://www.brother.com/;
    description = "A driver for brother mfcj470dw printers to print over WiFi and USB";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    downloadPage = http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj470dw_us_eu_as&os=128;
  };
}
