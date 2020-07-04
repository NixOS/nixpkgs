{ stdenv, fetchFromGitHub,
  SDL2, cmake, curl, fontconfig, freetype, icu, jansson, libiconv, libpng,
  libpthreadstubs, libzip, libGLU, openssl, pkgconfig, speexdsp, zlib
}:

let
  version = "0.2.6";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "1vikbkg3wh5ngzdfilb6irbh6nqinf138qpdz8wz9izlvl8s36k4";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v1.0.14";
    sha256 = "1bqbia5y73v4r0sv5cvi5729jh2ns7cxn557blh715yxswk91590";
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
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  enableParallelBuilding = true;

  preFixup = "ln -s $out/share/openrct2 $out/bin/data";

  meta = with stdenv.lib; {
    description = "An open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = "https://openrct2.io/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ geistesk ];
  };
}
