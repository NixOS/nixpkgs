{ lib, stdenv
, fetchFromGitHub
, cmake
, expat
, fmt
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
, rapidjson
}:

stdenv.mkDerivation rec {
  pname = "osm2pgsql";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = pname;
    rev = version;
    hash = "sha256-MWJzCZdqvy/nH1Doj0fmGuzTubaHDnPOED7qgzvJ3ZU=";
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r contrib
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat fmt proj bzip2 zlib boost postgresql libosmium protozero rapidjson ]
    ++ lib.optional withLuaJIT luajit
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    "-DEXTERNAL_LIBOSMIUM=ON"
    "-DEXTERNAL_PROTOZERO=ON"
    "-DEXTERNAL_RAPIDJSON=ON"
    "-DEXTERNAL_FMT=ON"
  ] ++ lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

  meta = with lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://osm2pgsql.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik das-g ];
  };
}
