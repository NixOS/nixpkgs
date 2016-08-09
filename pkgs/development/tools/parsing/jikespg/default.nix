{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jikespg-1.3";

  src = fetchurl {
    url = mirror://sourceforge/jikes/jikespg-1.3.tar.gz;
    md5 = "eba183713d9ae61a887211be80eeb21f";
  };

  sourceRoot = "jikespg/src";

  installPhase =
    ''
      mkdir -p $out/bin
      cp jikespg $out/bin
    '';

  meta = {
    homepage = http://jikes.sourceforge.net/;
    description = "The Jikes Parser Generator";
    platforms = stdenv.lib.platforms.linux;
  };
}
