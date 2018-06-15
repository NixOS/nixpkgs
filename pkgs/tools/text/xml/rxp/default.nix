{stdenv, fetchurl} :

stdenv.mkDerivation rec {
  name = "rxp-${version}";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://debian/pool/main/r/rxp/rxp_${version}.orig.tar.gz";
    sha256 = "0y365r36wzj4xn1dzhb03spxljnrx8vwqbiwnnwz4630129gzpm6";
  };

  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    description = "A validating XML parser written in C";
    homepage = http://www.cogsci.ed.ac.uk/~richard/rxp.html;
    platforms = stdenv.lib.platforms.unix;
  };
}
