{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, gettext
, libpng
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  pname = "the-legend-of-edgar";
  version = "1.35";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "riksweeney";
    repo = "edgar";
    rev = version;
    hash = "sha256-ojy4nEW9KiSte/AoFUMPrKCxvIeQpMVIL4ileHiBydo=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libpng
    zlib
  ];

  dontConfigure = true;

  makefile = "makefile";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BIN_DIR=${placeholder "out"}/bin/"
  ];

  # TODO: remove the setting below when the next version arrives
  # https://github.com/riksweeney/edgar/pull/57
  preBuild = ''
    export CFLAGS=$(sdl2-config --cflags)
  '';

  meta = with lib; {
    homepage = "https://www.parallelrealities.co.uk/games/edgar";
    description = "A 2D platform game with a persistent world";
    longDescription = ''
      When Edgar's father fails to return home after venturing out one dark and
      stormy night, Edgar fears the worst: he has been captured by the evil
      sorcerer who lives in a fortress beyond the forbidden swamp.

      Donning his armour, Edgar sets off to rescue him, but his quest will not
      be easy...

      The Legend of Edgar is a platform game, not unlike those found on the
      Amiga and SNES. Edgar must battle his way across the world, solving
      puzzles and defeating powerful enemies to achieve his quest.
    '';
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
