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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = pname;
    rev = version;
    sha256 = "sha256-6FVMv+DowMYdRdsQFL2iwG/V9D2cLWkHUVkmR3/TuUI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat proj bzip2 zlib boost postgresql libosmium protozero ]
    ++ lib.optional withLuaJIT luajit
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [ "-DEXTERNAL_LIBOSMIUM=ON" "-DEXTERNAL_PROTOZERO=ON" ]
    ++ lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

  meta = with lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://osm2pgsql.org";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ jglukasik das-g ];
  };
}
