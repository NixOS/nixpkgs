{ lib, stdenv, fetchFromGitHub
, SDL2, cmake, curl, duktape, fontconfig, freetype, icu, jansson, libGLU
, libiconv, libpng, libpthreadstubs, libzip, nlohmann_json, openssl, pkg-config
, speexdsp, zlib
}:

let
  version = "0.3.3";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "01nanpbz5ycdhkyd46fjfvj18sw729l4vk7xg12600f9rjngjk76";
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
  inherit version;
  pname = "openrct2";

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

  postUnpack = ''
    cp -r ${objects-src}         $sourceRoot/data/object
    cp -r ${title-sequences-src} $sourceRoot/data/sequence
  '';

  cmakeFlags = [
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  preFixup = "ln -s $out/share/openrct2 $out/bin/data";

  meta = with lib; {
    description = "An open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = "https://openrct2.io/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
