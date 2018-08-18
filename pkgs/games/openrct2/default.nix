{ stdenv, fetchFromGitHub,
  SDL2, cmake, curl, fontconfig, freetype, icu, jansson, libiconv, libpng,
  libpthreadstubs, libzip, libGLU, openssl, pkgconfig, speexdsp, zlib
}:

let
  name = "openrct2-${version}";
  version = "0.2.0";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "1nmz8war8b49iicpc70gk7zlqizrvvwpidqm70lfpa0p68m7m3px";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v1.0.2";
    sha256 = "1gl37fmhhrfgd6gilw0n7hfdq80a9b31bi5r0xhxg7d579jccb04";
  };

  title-sequences-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "title-sequences";
    rev = "v0.1.2";
    sha256 = "1yb1ynkfmiankii3fngr9km5wbc07rp30nh0apkj6wryrhy7imgm";
  };
in
stdenv.mkDerivation rec {
  inherit name;

  src = openrct2-src;

  buildInputs = [
    SDL2
    cmake
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
    pkgconfig
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
