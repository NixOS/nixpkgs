{ stdenv, fetchurl, redland, pkgconfig, gmp, zlib, librdf_raptor2
  , librdf_rasqal }:

stdenv.mkDerivation rec {
  name = "redstore-0.5.2";

  src = fetchurl {
    url = "http://www.aelius.com/njh/redstore/${name}.tar.gz";
    sha256 = "fdbe499a7bbe8c8a756ecb738b83ea375e96af16a1d74245b75600d4d40adb7d";
  };

  buildInputs = [ gmp pkgconfig redland zlib librdf_raptor2 librdf_rasqal ];

  preConfigure = ''
    # Define _XOPEN_SOURCE to enable, e.g., getaddrinfo.
    configureFlagsArray+=(
      "CFLAGS=-D_XOPEN_SOURCE=600 -I${librdf_raptor2}/include/raptor2 -I${librdf_rasqal}/include/rasqal"
    )
  '';

  meta = {
    description = "An HTTP interface to Redland RDF store";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms;
      linux ++ freebsd ++ gnu;
  };
}
