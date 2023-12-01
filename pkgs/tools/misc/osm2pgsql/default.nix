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
, python3
, withLuaJIT ? false
, lua
, luajit
, libosmium
, nlohmann_json
, opencv
, potrace
, protozero
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm2pgsql";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "osm2pgsql-dev";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
    hash = "sha256-IFAQ7iA37QXnWOSxUjh9EW7ss85k0h948JGuuUcpr5w=";
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r contrib
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    bzip2
    expat
    fmt
    libosmium
    nlohmann_json
    opencv
    postgresql
    potrace
    proj
    protozero
    (python3.withPackages (p: with p; [ psycopg2 pyosmium ]))
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
