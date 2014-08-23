{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "atool-0.39.0";
  src = fetchurl {
    url = mirror://savannah/atool/atool-0.39.0.tar.gz;
    sha256 = "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b";
  };

  buildInputs = [ perl ];

  meta = {
    homepage = http://www.nongnu.org/atool;
    description = "Archive command line helper";
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
