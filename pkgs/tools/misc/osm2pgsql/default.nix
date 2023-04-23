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
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm2pgsql";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
    hash = "sha256-8Jefd8dfoh/an7wd+8iTM0uOKA4UiUo8t2WzZs4r/Ck=";
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r contrib
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ expat fmt proj bzip2 zlib boost postgresql libosmium protozero ]
    ++ lib.optional withLuaJIT luajit
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    "-DEXTERNAL_LIBOSMIUM=ON"
    "-DEXTERNAL_PROTOZERO=ON"
    "-DEXTERNAL_FMT=ON"
  ] ++ lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "OpenStreetMap data to PostgreSQL converter";
    homepage = "https://osm2pgsql.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jglukasik das-g ];
  };
})
