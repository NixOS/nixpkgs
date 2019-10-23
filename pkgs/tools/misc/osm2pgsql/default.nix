{ stdenv, fetchFromGitHub, cmake, expat, proj, bzip2, zlib, boost, postgresql, lua}:

stdenv.mkDerivation rec {
  pname = "osm2pgsql";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = pname;
    rev = version;
    sha256 = "1g9qc1z5gzdjd37n586vcmq1qli0lkhbnsrnky0mf22szzv8iwfx";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat proj bzip2 zlib boost postgresql lua ];

  NIX_CFLAGS_COMPILE = [ "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H" ];

  meta = with stdenv.lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://github.com/openstreetmap/osm2pgsql";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jglukasik ];
  };
}
