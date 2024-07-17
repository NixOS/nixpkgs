{
  lib,
  stdenv,
  fetchurl,
  redland,
  pkg-config,
  gmp,
  zlib,
  librdf_raptor2,
  librdf_rasqal,
}:

stdenv.mkDerivation rec {
  pname = "redstore";
  version = "0.5.4";

  src = fetchurl {
    url = "https://www.aelius.com/njh/redstore/redstore-${version}.tar.gz";
    sha256 = "0hc1fjfbfvggl72zqx27v4wy84f5m7bp4dnwd8g41aw8lgynbgaq";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gmp
    redland
    zlib
    librdf_raptor2
    librdf_rasqal
  ];

  preConfigure = ''
    # Define _XOPEN_SOURCE to enable, e.g., getaddrinfo.
    configureFlagsArray+=(
      "CFLAGS=-D_XOPEN_SOURCE=600 -I${librdf_raptor2}/include/raptor2 -I${librdf_rasqal}/include/rasqal"
    )
  '';

  meta = {
    description = "An HTTP interface to Redland RDF store";
    mainProgram = "redstore";
    homepage = "https://www.aelius.com/njh/redstore/";
    maintainers = [ lib.maintainers.raskin ];
    platforms = with lib.platforms; linux ++ freebsd ++ gnu;
    license = lib.licenses.gpl3Plus;
  };
}
