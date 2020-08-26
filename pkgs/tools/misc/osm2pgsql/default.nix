{ stdenv
, fetchFromGitHub
, cmake
, expat
, proj
, bzip2
, zlib
, boost
, postgresql
, withLuaJIT ? false
, lua
, luajit
, libosmium
, protozero
}:

stdenv.mkDerivation rec {
  pname = "osm2pgsql";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = pname;
    rev = version;
    sha256 = "1dsyhcifixmcw05qxjald02pml0zfdij81pgy9yh8p00v0rqq57x";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat proj bzip2 zlib boost postgresql libosmium protozero ]
    ++ stdenv.lib.optional withLuaJIT luajit
    ++ stdenv.lib.optional (!withLuaJIT) lua;

  cmakeFlags = [ "-DEXTERNAL_LIBOSMIUM=ON" "-DEXTERNAL_PROTOZERO=ON" ]
    ++ stdenv.lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

  NIX_CFLAGS_COMPILE = "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H";

  meta = with stdenv.lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://github.com/openstreetmap/osm2pgsql";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ jglukasik das-g ];
  };
}
