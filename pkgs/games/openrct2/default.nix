{ lib, stdenv, fetchFromGitHub
, SDL2, cmake, curl, duktape, fontconfig, freetype, icu, jansson, libGLU
, libiconv, libpng, libpthreadstubs, libzip, nlohmann_json, openssl, pkgconfig
, speexdsp, zlib
}:

let
  version = "0.3.2";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "1fd32wniiy6qz2046ppqfj2sb3rf2qf086rf9v1bdhyj254d0b1z";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v1.0.18";
    sha256 = "1v9424kxdppg8vszv0vyq91lzljkrjc3nmk58wbwlpcwj6dip07s";
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
    pkgconfig
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
