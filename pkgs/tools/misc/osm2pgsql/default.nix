{ lib, stdenv
, fetchFromGitHub
, cmake
, expat
, fmt
, proj
, bzip2
, zlib
, boost
<<<<<<< HEAD
, cimg
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, postgresql
, withLuaJIT ? false
, lua
, luajit
, libosmium
<<<<<<< HEAD
, nlohmann_json
, potrace
, protozero
=======
, protozero
, rapidjson
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osm2pgsql";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "osm2pgsql";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-ZIjT4uKJas5RgxcMSoR8hWCM9pdu3hSzWwfIn1ZvU8Y=";
=======
    hash = "sha256-8Jefd8dfoh/an7wd+8iTM0uOKA4UiUo8t2WzZs4r/Ck=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # Remove bundled libraries
    rm -r contrib
  '';

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
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
=======
  buildInputs = [ expat fmt proj bzip2 zlib boost postgresql libosmium protozero ]
    ++ lib.optional withLuaJIT luajit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    "-DEXTERNAL_LIBOSMIUM=ON"
    "-DEXTERNAL_PROTOZERO=ON"
    "-DEXTERNAL_FMT=ON"
  ] ++ lib.optional withLuaJIT "-DWITH_LUAJIT:BOOL=ON";

<<<<<<< HEAD
  installFlags = [ "install-gen" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
