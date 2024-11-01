{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf
, pango, gettext, boost, libvorbis, fribidi, dbus, libpng, pcre, openssl, icu
, lua, curl
, Cocoa, Foundation
}:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.18.2";

  src = fetchFromGitHub {
    rev = version;
    owner = "wesnoth";
    repo = "wesnoth";
    hash = "sha256-nr+WUFzHeaPxCzwc+8JZRL86X8XEsnsGM1HXnNqOIF0=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf pango gettext boost
                  libvorbis fribidi dbus libpng pcre openssl icu lua curl ]
                ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa Foundation];

  cmakeFlags = [
    "-DENABLE_SYSTEM_LUA=ON"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AppKit";

  meta = with lib; {
    description = "Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = "https://www.wesnoth.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
