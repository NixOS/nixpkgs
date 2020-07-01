{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jikespg-1.3";

  src = fetchurl {
    url = "mirror://sourceforge/jikes/${name}.tar.gz";
    sha256 = "083ibfxaiw1abxmv1crccx1g6sixkbyhxn2hsrlf6fwii08s6rgw";
  };

  sourceRoot = "jikespg/src";

  installPhase =
    ''
      mkdir -p $out/bin
      cp jikespg $out/bin
    '';

  meta = with stdenv.lib; {
    homepage = "http://jikes.sourceforge.net/";
    description = "The Jikes Parser Generator";
    platforms = platforms.linux;
    license = licenses.ipl10;
    maintainers = with maintainers; [ pSub ];
  };
}
