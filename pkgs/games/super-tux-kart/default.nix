{ fetchurl, stdenv, plib, SDL, openal, freealut, mesa
, libvorbis, libogg, gettext }:

stdenv.mkDerivation rec {
  name = "supertuxkart-0.6.2a";

  src = fetchurl {
    url = "mirror://sourceforge/supertuxkart/${name}-src.tar.bz2";
    sha256 = "0bdn12kg85bgcgj9shfc40k56228hysiixfaxkycgb688nhldngr";
  };

  buildInputs = [
    plib SDL openal freealut mesa libvorbis libogg gettext
  ];

  postInstall = ''
    mv $out/games $out/bin
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
