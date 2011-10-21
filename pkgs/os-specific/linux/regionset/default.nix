{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "regionset-20030629";

  src = fetchurl {
    url = "mirror://sourceforge/dvd/regionset.tar.gz";
    sha256 = "0ssr7s0g60kq04y8v60rh2fzn9wp93al3v4rl0ybza1skild9v70";
  };

  installPhase = "mkdir -p $out/sbin; cp regionset $out/sbin";

  meta = {
    homepage = http://dvd.sourceforge.net/;
    descriptions = "Tool for changing the region code setting of DVD players";
    platforms = stdenv.lib.platforms.linux;
  };
}
