{ stdenv, fetchurl, cups, dpkg, ghostscript, a2ps, coreutils, gnused, gawk, file, makeWrapper, pkgs }:

stdenv.mkDerivation rec {
  name = "mfc9340cdwlpr-${version}";
  version = "1.1.2-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf007027/${name}.i386.deb";
    sha256 = "1zldpi26n969j5q8z16m8k0wl174cjbfnfra1rl09n8x747h5485";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    dpkg-deb -x $src $out

    substituteInPlace $out/opt/brother/Printers/mfc9340cdw/lpd/filtermfc9340cdw \
      --replace /opt "$out/opt" \

    wrapProgram $out/opt/brother/Printers/mfc9340cdw/lpd/filtermfc9340cdw \
      --prefix PATH ":" ${ stdenv.lib.makeBinPath [ ghostscript a2ps file gnused coreutils ] }

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/mfc9340cdw/lpd/psconvertij2

    wrapProgram $out/opt/brother/Printers/mfc9340cdw/lpd/psconvertij2 \
      --prefix PATH ":" ${ stdenv.lib.makeBinPath [ ghostscript gnused coreutils gawk ] }

    patchelf --set-interpreter ${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2 $out/opt/brother/Printers/mfc9340cdw/lpd/brmfc9340cdwfilter
  '';

  meta = {
    description = "Brother MFC-9340CDW LPR printer driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
