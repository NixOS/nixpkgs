{ stdenv, fetchurl, fetchpatch, sconsPackages, pkgconfig, SDL, libGLU_combined, zlib, smpeg
, SDL_image, libvorbis, expat, zip, lua5_1 }:

stdenv.mkDerivation rec {
  name = "battle-tanks-0.9.8083";

  src = fetchurl {
    url = mirror://sourceforge/btanks/btanks-0.9.8083.tar.bz2;
    sha256 = "0ha35kxc8xlbg74wsrbapfgxvcrwy6psjkqi7c6adxs55dmcxliz";
  };

  nativeBuildInputs = [ sconsPackages.scons_3_0_1 pkgconfig ];
  buildInputs = [ SDL libGLU_combined zlib smpeg SDL_image libvorbis expat zip lua5_1 ];

  NIX_CFLAGS_COMPILE = "-I${SDL_image}/include/SDL";

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/b/btanks/0.9.8083-7/debian/patches/gcc-4.7.patch";
      sha256 = "1dxlk1xh69gj10sqcsyckiakb8an3h41206wby4z44mpmvxc7pi4";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/b/btanks/0.9.8083-7/debian/patches/pow10f.patch";
      sha256 = "1h45790v2dpdbccfn6lwfgl8782q54i14cz9gpipkaghcka4y0g9";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/btanks/;
    description = "Fast 2d tank arcade game";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
