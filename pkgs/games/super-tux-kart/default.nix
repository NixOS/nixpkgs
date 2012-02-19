{ fetchurl, stdenv, plib, SDL, openal, freealut, mesa
, libvorbis, libogg, gettext, irrlicht3843, libXxf86vm, curl, pkgconfig
, fribidi }:

stdenv.mkDerivation rec {
  name = "supertuxkart-0.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/supertuxkart/${name}-src.tar.bz2";
    sha256 = "0njrs2qyhbiqdbsqk9jx0sl8nhdwmipf1i91k23rv1biwrim9yq7";
  };

  buildInputs = [
    plib SDL openal freealut mesa libvorbis libogg gettext irrlicht3843
    libXxf86vm curl pkgconfig fribidi
  ];

  configureFlags = [ "--with-irrlicht=${irrlicht3843}" ];

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
