{ stdenv, fetchurl, cmake, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf, pango
, gettext, zlib, boost, freetype, libpng, pkgconfig, lua, dbus, fontconfig, libtool
, fribidi, asciidoc }:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.10.7";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "0gi5fzij48hmhhqxc370jxvxig5q3d70jiz56rjn8yx514s5lfwa";
  };

  buildInputs = [ SDL SDL_image SDL_mixer SDL_net SDL_ttf pango gettext zlib
                  boost fribidi cmake freetype libpng pkgconfig lua
                  dbus fontconfig libtool ];

  cmakeFlags = [ "-DENABLE_STRICT_COMPILATION=FALSE" ]; # newer gcc problems http://gna.org/bugs/?21030

  enableParallelBuilding = true;

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
