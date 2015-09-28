{ stdenv, fetchurl, perl, AlgorithmDiff, RegexpCommon }:

stdenv.mkDerivation rec {

  name = "cloc-${version}";

  version = "1.64";

  src = fetchurl {
    url = "mirror://sourceforge/cloc/cloc-${version}.tar.gz";
    sha256 = "1w3mz69h2i7pscvi9q7yp7wimds8g38c5ph78cj5pvjl5wa035rh";
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
