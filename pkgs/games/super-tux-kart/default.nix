{ fetchurl, stdenv, plib, SDL, openal, freealut, mesa
, libvorbis, libogg, gettext }:

stdenv.mkDerivation rec {
  name = "supertuxkart-0.6.1a";

  src = fetchurl {
    url = "mirror://sourceforge/supertuxkart/${name}.tar.bz2";
    sha256 = "1p4jl4v74f7ff7qkw10k48fvyg247wqzc097ds07y3pvn9a696w4";
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
