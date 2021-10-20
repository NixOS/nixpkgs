{lib, stdenv, fetchurl}:
stdenv.mkDerivation rec {
  pname = "fairymax";
  version = "4.8";
  src = fetchurl {
    url = "http://home.hccnet.nl/h.g.muller/fmax4_8w.c";
    sha256 = "01vxhpa4z0613mkgkzmsln293wxmyp5kdzil93cd1ik51q4gwjca";
  };
  ini = fetchurl {
    url = "http://home.hccnet.nl/h.g.muller/fmax.ini";
    sha256 = "1zwx70g3gspbqx1zf9gm1may8jrli9idalvskxbdg33qgjys47cn";
  };
  unpackPhase = ''
    cp ${src} fairymax.c
    cp ${ini} fmax.ini
  '';
  buildPhase = ''
    $CC *.c -Wno-return-type -o fairymax -DINI_FILE='"'"$out/share/fairymax/fmax.ini"'"'
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,share/fairymax}
    cp fairymax "$out/bin"
    cp fmax.ini "$out/share/fairymax"
  '';
  meta = {
    description = "A small chess engine supporting fairy pieces";
    longDescription = ''
       A version of micro-Max that reads the piece description
       from a file fmax.ini, so that arbitrary fairy pieces can be
       implemented. This version (4.8J) supports up to 15 piece types,
       and board sizes up to 12x8. A Linux port exists in the
       format of a debian package.
    '';
    license = lib.licenses.free ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.all;
    homepage = "http://home.hccnet.nl/h.g.muller/dwnldpage.html";
  };
}
