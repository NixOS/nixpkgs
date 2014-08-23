{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "sl-3.03";

  src = fetchurl {
    url = "http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/sl/sl.tar";
    sha256 = "1x3517aza0wm9hhb02npl8s7xy947cdidxmans27q0gjmj3bvg5j";
  };

  patchPhase = ''
    sed -i "s/-lcurses -ltermcap/-lncurses/" Makefile
  '';

  buildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/bin
    cp sl $out/bin
  '';

  meta = {
    homepage = http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html;
    license = rec {
      shortName = "Toyoda Masashi's free software license";
      fullName = shortName;
      url = https://github.com/mtoyoda/sl/blob/master/LICENSE;
    };
    description = "Steam Locomotive runs across your terminal when you type 'sl'";
    platforms = with stdenv.lib.platforms; linux;
  };
}
