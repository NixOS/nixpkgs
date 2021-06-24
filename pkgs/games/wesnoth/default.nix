{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, SDL2, SDL2_image, SDL2_mixer, SDL2_net, SDL2_ttf
, pango, gettext, boost, libvorbis, fribidi, dbus, libpng, pcre, openssl, icu
, Cocoa, Foundation
, enableTools ? false
}:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.14.16";

  src = fetchFromGitHub {
    rev = version;
    owner = "wesnoth";
    repo = "wesnoth";
    sha256 = "sha256-QMz7atxol18r//UNb6+H6xAAEQdR4hAN8UW0KeGSH1g=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_net SDL2_ttf pango gettext boost
                  libvorbis fribidi dbus libpng pcre openssl icu ]
                ++ lib.optionals stdenv.isDarwin [ Cocoa Foundation];

  cmakeFlags = [ "-DENABLE_TOOLS=${if enableTools then "ON" else "OFF"}" ];

  meta = with lib; {
    description = "The Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = "https://www.wesnoth.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
