{ stdenv, fetchurl, fetchpatch, scons, pkgconfig, SDL, mesa, zlib, smpeg
, SDL_image, libvorbis, expat, zip, lua5_1 }:

stdenv.mkDerivation rec {
  name = "battle-tanks-0.9.8083";

  src = fetchurl {
    url = mirror://sourceforge/btanks/btanks-0.9.8083.tar.bz2;
    sha256 = "0ha35kxc8xlbg74wsrbapfgxvcrwy6psjkqi7c6adxs55dmcxliz";
  };

  nativeBuildInputs = [ scons pkgconfig ];
  buildInputs = [ SDL mesa zlib smpeg SDL_image libvorbis expat zip lua5_1 ];

  NIX_CFLAGS_COMPILE = "-I${SDL_image}/include/SDL";

  patches = [ (fetchpatch {
    name = "gcc-4.7.patch";
    url = "https://anonscm.debian.org/viewvc/pkg-games/packages/trunk/btanks/debian/patches/gcc-4.7.patch?revision=13641&view=co&pathrev=15758";
    sha256 = "1dxlk1xh69gj10sqcsyckiakb8an3h41206wby4z44mpmvxc7pi4";
  }) ];

  buildPhase = ''
    scons prefix=$out
  '';

  installPhase = ''
    scons install
  '';

  meta = {
    homepage = https://sourceforge.net/projects/btanks/;
    description = "Fast 2d tank arcade game";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
