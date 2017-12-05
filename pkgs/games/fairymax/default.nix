{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "fairymax-${version}";
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
    gcc *.c -o fairymax -DINI_FILE='"'"$out/share/fairymax/fmax.ini"'"'
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,share/fairymax}
    cp fairymax "$out/bin"
    cp fmax.ini "$out/share/fairymax"
  '';
  meta = {
    inherit version;
    description = ''A small chess engine supporting fairy pieces'';
    longDescription = ''
       A version of micro-Max that reads the piece description
       from a file fmax.ini, so that arbitrary fairy pieces can be
       implemented. This version (4.8J) supports up to 15 piece types,
       and board sizes up to 12x8. A Linux port exists in the
       format of a debian package.
    '';
    license = stdenv.lib.licenses.free ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://home.hccnet.nl/h.g.muller/dwnldpage.html;
  };
}
