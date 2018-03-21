{ stdenv, fetchurl, fetchFromGitHub,
  SDL2, cmake, curl, fontconfig, freetype, jansson, libiconv, libpng,
  libpthreadstubs, libzip, libGLU, openssl, pkgconfig, speexdsp, zlib
}:

let
  name = "openrct2-${version}";
  version = "0.1.2";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "1zqrdxr79c9yx4bdxz1r5866hhwq0lcs9qpv3vhisr56ar5n5wk3";
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
    cp -r ${title-sequences-src} $sourceRoot/title
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RELWITHDEBINFO" "-DDOWNLOAD_TITLE_SEQUENCES=OFF"];

  makeFlags = ["all" "g2"];

  preFixup = "ln -s $out/share/openrct2 $out/bin/data";

  meta = with stdenv.lib; {
    description = "An open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = https://openrct2.website/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ geistesk ];
  };
}
