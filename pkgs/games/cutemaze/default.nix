{ stdenv, fetchurl, qmake, qttools, qtsvg }:

stdenv.mkDerivation rec {
  name = "cutemaze-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "https://gottcode.org/cutemaze/${name}-src.tar.bz2";
    sha256 = "841f2a208770c9de6009fed64e24a059a878686c444c4b572c56b564e4cfa66e";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtsvg ];

  meta = with stdenv.lib; {
    homepage = https://gottcode.org/cutemaze/;
    description = "Simple, top-down game in which mazes are randomly generated";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    # TODO: add darwin once tested
    platforms = with platforms; linux;
  };
}
