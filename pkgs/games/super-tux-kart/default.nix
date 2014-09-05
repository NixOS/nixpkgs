{ fetchurl, cmake, stdenv, plib, SDL, openal, freealut, mesa
, libvorbis, libogg, gettext, libXxf86vm, curl, pkgconfig
, fribidi, autoconf, automake, libtool, bluez }:

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "supertuxkart-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/supertuxkart/${name}-src.tar.bz2";
    sha256 = "1mpqmi62a2kl6n58mw11fj0dr5xiwmjkqnfmd2z7ghdhc6p02lrk";
  };

  buildInputs = [
    plib SDL openal freealut mesa libvorbis libogg gettext
    libXxf86vm curl pkgconfig fribidi autoconf automake libtool cmake bluez
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    echo Building internal Irrlicht
    cd lib/irrlicht/source/Irrlicht/
    cp "${mesa}"/include/GL/{gl,glx,wgl}ext.h .
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
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
