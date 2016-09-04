{ stdenv, fetchurl, redland, pkgconfig, gmp, zlib, librdf_raptor2
  , librdf_rasqal }:

stdenv.mkDerivation rec {
  name = "redstore-0.5.4";

  src = fetchurl {
    url = "http://www.aelius.com/njh/redstore/${name}.tar.gz";
    sha256 = "0hc1fjfbfvggl72zqx27v4wy84f5m7bp4dnwd8g41aw8lgynbgaq";
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
    homepage = https://www.aelius.com/njh/redstore/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms;
      linux ++ freebsd ++ gnu;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
