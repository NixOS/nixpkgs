{ stdenv, fetchurl, fetchFromGitHub,
  SDL2, cmake, curl, fontconfig, freetype, jansson, libiconv, libpng,
  libpthreadstubs, libzip, libGLU, openssl, pkgconfig, speexdsp, zlib
}:

let
  name = "openrct2-${version}";
  version = "0.1.1";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "1xxwqx2gzvsdrsy76rz3sys9m4pyn9q25nbnkba3cw1z4l2b73lg";
  };

  title-sequences-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "title-sequences";
    rev = "v0.1.0";
    sha256 = "17c926lhby90ilvyyl6jsiy0df8dw5jws97xigp3x8hddhvv7c16";
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
