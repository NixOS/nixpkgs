{ stdenv, fetchurl, fetchpatch, sconsPackages, pkgconfig, SDL, libGL, zlib, smpeg
, SDL_image, libvorbis, expat, zip, lua }:

stdenv.mkDerivation rec {
  pname = "btanks";
  version = "0.9.8083";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0ha35kxc8xlbg74wsrbapfgxvcrwy6psjkqi7c6adxs55dmcxliz";
  };

  nativeBuildInputs = [ sconsPackages.scons_3_0_1 pkgconfig ];

  buildInputs = [ SDL libGL zlib smpeg SDL_image libvorbis expat zip lua ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-I${SDL_image}/include/SDL";

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/lua52.patch?h=btanks";
      sha256 = "0ip563kz6lhwiims5djrxq3mvb7jx9yzkpsqxxhbi9n6qzz7y2az";
      name = "lua52.patch";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/raw/master/debian/patches/gcc-4.7.patch";
      sha256 = "1dxlk1xh69gj10sqcsyckiakb8an3h41206wby4z44mpmvxc7pi4";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/btanks/raw/master/debian/patches/pow10f.patch";
      sha256 = "1h45790v2dpdbccfn6lwfgl8782q54i14cz9gpipkaghcka4y0g9";
    })
  ];

  meta = with stdenv.lib; {
    description = "Fast 2d tank arcade game";
    homepage = "https://sourceforge.net/projects/btanks/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
