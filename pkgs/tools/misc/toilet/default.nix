{ lib, stdenv, fetchurl, pkg-config, libcaca }:

stdenv.mkDerivation rec {
  pname = "toilet";
  version = "0.3";

  src = fetchurl {
    url = "http://caca.zoy.org/raw-attachment/wiki/toilet/${pname}-${version}.tar.gz";
    sha256 = "1pl118qb7g0frpgl9ps43w4sd0psjirpmq54yg1kqcclqcqbbm49";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libcaca ];

  meta = with lib; {
    description = "Display large colourful characters in text mode";
    homepage = "http://caca.zoy.org/wiki/toilet";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.all;
  };
}
