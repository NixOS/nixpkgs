{ stdenv, fetchFromGitHub,
  SDL2, cmake, curl, fontconfig, freetype, icu, jansson, libiconv, libpng,
  libpthreadstubs, libzip, libGLU, openssl, pkgconfig, speexdsp, zlib
}:

let
  name = "openrct2-${version}";
  version = "0.2.4";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "1rlw3w20llg36sj3bk50g661qw766ng8ma3p42sdkj8br9dw800h";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v1.0.12";
    sha256 = "0vfhyldc8nfvkg4d9kry669haxz2165walbxzgza7pqpnd7aqgrf";
  };

  title-sequences-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "title-sequences";
    rev = "v0.1.2c";
    sha256 = "1qdrm4q75bznmgdrpjdaiqvbf3q4vwbkkmls45izxvyg1djrpsdf";
  };
in
stdenv.mkDerivation {
  inherit name;

  src = openrct2-src;

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    SDL2
    curl
    fontconfig
    freetype
    icu
    jansson
    libiconv
    libpng
    libpthreadstubs
    libzip
    libGLU
    openssl
    speexdsp
    zlib
  ];

  postUnpack = ''
    cp -r ${objects-src}         $sourceRoot/data/object
    cp -r ${title-sequences-src} $sourceRoot/data/title
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RELWITHDEBINFO"
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  makeFlags = ["all" "g2"];

  preFixup = "ln -s $out/share/openrct2 $out/bin/data";

  meta = with stdenv.lib; {
    description = "An open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = https://openrct2.io/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ geistesk ];
  };
}
