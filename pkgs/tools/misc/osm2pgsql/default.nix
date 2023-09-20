{ lib, stdenv
, fetchFromGitHub
, cmake
, expat
, fmt
, proj
, bzip2
, zlib
, boost
, cimg
, postgresql
, withLuaJIT ? false
, lua
, luajit
, libosmium
, nlohmann_json
, potrace
, protozero
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm2pgsql";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
    hash = "sha256-ZIjT4uKJas5RgxcMSoR8hWCM9pdu3hSzWwfIn1ZvU8Y=";
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r contrib
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    bzip2
    cimg
    expat
    fmt
    libosmium
    nlohmann_json
    postgresql
    potrace
    proj
    protozero
    zlib
  ] ++ lib.optional withLuaJIT luajit
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    "-DEXTERNAL_LIBOSMIUM=ON"
    "-DEXTERNAL_PROTOZERO=ON"
    "-DEXTERNAL_FMT=ON"
  ] ++ lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

  installFlags = [ "install-gen" ];

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
