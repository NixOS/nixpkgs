{ stdenv, fetchFromGitHub, cmake, expat, proj, bzip2, zlib, boost, postgresql, lua}:

stdenv.mkDerivation rec {
  name = "osm2pgsql-${version}";
  version = "0.96.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "osm2pgsql";
    rev = version;
    sha256 = "032cydh8ynaqfhdzmkvgbmqyjql668y6qln1l59l2s3ni9963bbl";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat proj bzip2 zlib boost postgresql lua ];

  NIX_CFLAGS_COMPILE = [ "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H" ];

  meta = with stdenv.lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = https://github.com/openstreetmap/osm2pgsql;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
