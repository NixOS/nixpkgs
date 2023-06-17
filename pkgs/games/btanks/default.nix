{ lib, stdenv, fetchurl, fetchpatch, scons, pkg-config, SDL, libGL, zlib, smpeg
, SDL_image, libvorbis, expat, zip, lua }:

stdenv.mkDerivation rec {
  pname = "btanks";
  version = "0.9.8083";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-P9LOaitF96YMOxFPqa/xPLPdn7tqZc3JeYt2xPosQ0E=";
  };

  nativeBuildInputs = [ scons pkg-config ];

  buildInputs = [ SDL libGL zlib smpeg SDL_image libvorbis expat zip lua ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-I${SDL_image}/include/SDL";

  patches = [
    (fetchpatch {
      name = "lua52.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/lua52.patch?h=btanks&id=cd0e016963238f16209baa2da658aa3fad36e33d";
      hash = "sha256-Xwl//sfGprhg71jf+X3q8qxdB+5ZtqJrjBxS8+cw5UY=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/gcc-4.7.patch";
      hash = "sha256-JN7D+q63EvKJX9wAEQgcVqE1VZzMa4Y1CPIlA3uYtLc=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/pow10f.patch";
      hash = "sha256-6QFP1GTwqXnjfekzEiIpWKCD6HOcGusYW+02sUE6hcA=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/python3.patch";
      hash = "sha256-JpK409Myi8mxQaunmLFKKh1NKvKLXpNHHsDvRee8OoQ=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/-/raw/debian/0.9.8083-9/debian/patches/scons.patch";
      hash = "sha256-JCvBY2fOV8Sc/mpvEsJQv1wKcS1dHqYxvRk6I9p7ZKc=";
    })
  ];

  meta = with lib; {
    description = "Fast 2d tank arcade game";
    homepage = "https://sourceforge.net/projects/btanks/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
