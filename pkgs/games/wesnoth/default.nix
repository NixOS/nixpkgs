{ stdenv, fetchurl, cmake, pkgconfig, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf
, pango, gettext, boost, freetype, libvorbis, fribidi, dbus, libpng, pcre
, enableTools ? false
}:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.12.6";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "0kifp6g1dsr16m6ngjq2hx19h851fqg326ps3krnhpyix963h3x5";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ SDL SDL_image SDL_mixer SDL_net SDL_ttf pango gettext boost
                  libvorbis fribidi dbus libpng pcre ];

  cmakeFlags = [ "-DENABLE_TOOLS=${if enableTools then "ON" else "OFF"}" ];

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
    maintainers = with maintainers; [ kkallio abbradar ];
    platforms = platforms.linux;
  };
}
