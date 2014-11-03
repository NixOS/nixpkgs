{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ised-${version}";
  version = "2.6.0";
  src = fetchurl {
    url = "mirror://sourceforge/project/ised/${name}.tar.bz2";
    sha256 = "0rf9brqkrad8f3czpfc1bxq9ybv3nxci9276wdxas033c82cqkjs";
  };

  meta = {
    description = "A numeric sequence editor";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
