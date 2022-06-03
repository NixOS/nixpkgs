{ lib, stdenv, fetchurl, cups, dpkg, ghostscript, a2ps, coreutils, gnused, gawk, file, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mfcj470dw-cupswrapper";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006843/mfcj470dwlpr-${version}.i386.deb";
    sha256 = "7202dd895d38d50bb767080f2995ed350eed99bc2b7871452c3c915c8eefc30a";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    substituteInPlace $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw \
    --replace /opt "$out/opt" \

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/mfcj470dw/lpd/psconvertij2

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/opt/brother/Printers/mfcj470dw/lpd/brmfcj470dwfilter

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw $out/lib/cups/filter/brother_lpdwrapper_mfcj470dw

    wrapProgram $out/opt/brother/Printers/mfcj470dw/lpd/psconvertij2 \
    --prefix PATH ":" ${ lib.makeBinPath [ gnused coreutils gawk ] }

    wrapProgram $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw \
    --prefix PATH ":" ${ lib.makeBinPath [ ghostscript a2ps file gnused coreutils ] }
    '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-J470DW LPR driver";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj470dw_us_eu_as&os=128";
    maintainers = [ lib.maintainers.yochai ];
  };
}
