{ fetchurl, stdenv, plib, SDL, openal, freealut, mesa
, libvorbis, libogg, gettext }:

stdenv.mkDerivation rec {
  name = "supertuxkart-0.5";

  src = fetchurl {
    url = "mirror://sourceforge/supertuxkart/${name}.tar.bz2";
    sha256 = "1c9gdfcsygsflbrsar38p6gm17kxnna70s9mw4bsixyg45aghii9";
  };

  buildInputs = [
    plib SDL openal freealut mesa libvorbis libogg gettext
  ];

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
