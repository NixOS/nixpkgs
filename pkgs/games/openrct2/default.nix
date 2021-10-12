{ lib, stdenv, fetchFromGitHub
, SDL2, cmake, curl, duktape, fontconfig, freetype, icu, jansson, libGLU
, libiconv, libpng, libpthreadstubs, libzip, nlohmann_json, openssl, pkg-config
, speexdsp, zlib
}:

let
  version = "0.3.4.1";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "0zjqn47pbgd2nrrbdl3lqk1mcdvwvvpjby2g0gfv6ssfw72fji7d";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v1.0.21";
    sha256 = "0r2vp2y67jc1mpfl4j83sx5khvvaddx7xs26ppkigmr2d1xpxgr7";
  };

  title-sequences-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "title-sequences";
    rev = "v0.1.2c";
    sha256 = "1qdrm4q75bznmgdrpjdaiqvbf3q4vwbkkmls45izxvyg1djrpsdf";
  };
in
stdenv.mkDerivation {
  pname = "openrct2";
  inherit version;

  src = openrct2-src;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    curl
    duktape
    fontconfig
    freetype
    icu
    jansson
    libGLU
    libiconv
    libpng
    libpthreadstubs
    libzip
    nlohmann_json
    openssl
    speexdsp
    zlib
  ];

  cmakeFlags = [
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  postUnpack = ''
    cp -r ${objects-src}         $sourceRoot/data/object
    cp -r ${title-sequences-src} $sourceRoot/data/sequence
  '';

  preFixup = "ln -s $out/share/openrct2 $out/bin/data";

  meta = with lib; {
    description = "Open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = "https://openrct2.io/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
