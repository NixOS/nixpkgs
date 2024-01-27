{ lib, stdenv, fetchurl, libX11, xorgproto, gd, SDL, SDL_image, SDL_mixer, zlib
, libxml2, pkg-config, curl, cmake, libzip }:

stdenv.mkDerivation rec {
  pname = "openlierox";
  version = "0.58rc3";

  src = fetchurl {
    url = "mirror://sourceforge/openlierox/OpenLieroX_0.58_rc3.src.tar.bz2";
    sha256 = "1k35xppfqi3qfysv81xq3hj4qdy9j2ciinbkfdcmwclcsf3nh94z";
  };

  env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2 -std=c++98 -Wno-error";

  # The breakpad fails to build on x86_64, and it's only to report bugs upstream
  cmakeFlags = [ "-DBREAKPAD=0" ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DSYSTEM_DATA_DIR=$out/share"
  '';

  patchPhase = ''
    sed -i s,curl/types.h,curl/curl.h, include/HTTP.h src/common/HTTP.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/OpenLieroX
    cp bin/* $out/bin
    cp -R ../share/gamedir/* $out/share/OpenLieroX
  '';

  nativeBuildInputs = [ cmake pkg-config curl ];
  buildInputs = [ libX11 xorgproto gd SDL SDL_image SDL_mixer zlib libxml2
    libzip ];

  meta = {
    homepage = "http://openlierox.net";
    description = "Real-time game with Worms-like shooting";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
}
