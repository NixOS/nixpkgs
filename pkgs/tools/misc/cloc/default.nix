{ stdenv, fetchurl, perl, AlgorithmDiff, RegexpCommon }:

stdenv.mkDerivation rec {

  name = "cloc-${version}";

  version = "1.62";

  src = fetchurl {
    url = "mirror://sourceforge/cloc/cloc-${version}.tar.gz";
    sha256 = "1cxc663dccd0sc2m0aj5lxdbnbzrys6rh9n8q122h74bfvsiw4f4";
  };

  buildInputs = [ perl AlgorithmDiff RegexpCommon ];

  makeFlags = [ "prefix=" "DESTDIR=$(out)" "INSTALL=install" ];

  meta = {
    description = "A program that counts lines of source code";
    homepage = http://cloc.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };

}
