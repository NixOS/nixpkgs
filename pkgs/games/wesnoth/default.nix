{ stdenv, fetchurl, cmake, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf, pango
, gettext, zlib, boost, freetype, libpng, pkgconfig, lua, dbus, fontconfig, libtool
, fribidi, asciidoc }:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.10.2";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "0hawzq85sq0kdddj0s7y6kpx043g1hsl7cvyw1xcxqh45hkgw2ix";
  };

  buildInputs = [ SDL SDL_image SDL_mixer SDL_net SDL_ttf pango gettext zlib boost fribidi
                  cmake freetype libpng pkgconfig lua dbus fontconfig libtool ];

  # Make the package build with the gcc currently available in Nixpkgs.
  NIX_CFLAGS_COMPILE = "-Wno-ignored-qualifiers";

  meta = with stdenv.lib; {
    description = "The Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = http://www.wesnoth.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.kkallio ];
    platforms = platforms.linux;
  };
}
