{lib, stdenv, fetchurl} :

stdenv.mkDerivation rec {
  pname = "rxp";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://debian/pool/main/r/rxp/rxp_${version}.orig.tar.gz";
    sha256 = "0y365r36wzj4xn1dzhb03spxljnrx8vwqbiwnnwz4630129gzpm6";
  };

  meta = {
    license = lib.licenses.gpl2Plus;
    description = "A validating XML parser written in C";
    homepage = "https://www.cogsci.ed.ac.uk/~richard/rxp.html";
    platforms = lib.platforms.unix;
  };
}
