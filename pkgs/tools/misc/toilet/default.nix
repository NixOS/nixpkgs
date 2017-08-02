{ stdenv, fetchurl, pkgconfig, libcaca, figlet }:

stdenv.mkDerivation rec {
  name = "toilet-${version}";
  version = "0.3";

  src = fetchurl {
    url = "http://caca.zoy.org/raw-attachment/wiki/toilet/${name}.tar.gz";
    sha256 = "1pl118qb7g0frpgl9ps43w4sd0psjirpmq54yg1kqcclqcqbbm49";
  };

  buildInputs = [ pkgconfig libcaca ];

  meta = {
    description = "Display large colourful characters in text mode";
    homepage = http://caca.zoy.org/wiki/toilet;
    license = stdenv.lib.licenses.wtfpl;
    platforms = stdenv.lib.platforms.all;
  };
}
