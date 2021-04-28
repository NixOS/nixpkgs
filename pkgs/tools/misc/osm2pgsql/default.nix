{ lib, stdenv
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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = pname;
    rev = version;
    sha256 = "141blh6lwbgn8hh45xaa0yiwygdc444h9zahx5xrzx5pck9zb5ps";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat proj bzip2 zlib boost postgresql libosmium protozero ]
    ++ lib.optional withLuaJIT luajit
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [ "-DEXTERNAL_LIBOSMIUM=ON" "-DEXTERNAL_PROTOZERO=ON" ]
    ++ lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

  NIX_CFLAGS_COMPILE = "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H";

  meta = with lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://osm2pgsql.org";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ jglukasik das-g ];
  };
}
