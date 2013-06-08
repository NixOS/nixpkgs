{ fetchurl, cmake, stdenv, plib, SDL, openal, freealut, mesa
, libvorbis, libogg, gettext, libXxf86vm, curl, pkgconfig
, fribidi, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "supertuxkart-0.8";

  src = fetchurl {
    url = "mirror://sourceforge/supertuxkart/${name}-src.tar.bz2";
    sha256 = "12sbml4wxg2x2wgnnkxfisj96a9gcsaj3fj27kdk8yj524ikv7xr";
  };

  buildInputs = [
    plib SDL openal freealut mesa libvorbis libogg gettext
    libXxf86vm curl pkgconfig fribidi autoconf automake libtool cmake
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    echo Building internal Irrlicht
    cd lib/irrlicht/source/Irrlicht/
    NDEBUG=1 make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}
    cd -
  '';

  meta = {
    description = "SuperTuxKart is a Free 3D kart racing game";

    longDescription = ''
      SuperTuxKart is a Free 3D kart racing game, with many tracks,
      characters and items for you to try, similar in spirit to Mario
      Kart.
    '';

    homepage = http://supertuxkart.sourceforge.net/;

    license = "GPLv2+";
  };
}
