{ lib
, stdenv
, fetchurl
, gettext
, guile
, SDL
, SDL_image
, SDL_mixer
, SDL_ttf
}:

stdenv.mkDerivation rec {
  pname = "ballandpaddle";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://gnu/ballandpaddle/ballandpaddle-${version}.tar.gz";
    hash = "sha256-3oLRerAy6amX6wU3ggBT1qhGYbKD3xvnckdW0FTz930=";
  };

  patches = [
    ./getenv-decl.patch
  ];

  postPatch = ''
    sed -i "Makefile.in" \
        -e "s|desktopdir *=.*$|desktopdir = $out/share/applications|g ;
            s|pixmapsdir *=.*$|pixmapsdir = $out/share/pixmaps|g"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    SDL
  ];

  buildInputs = [
    guile
    SDL
    SDL_image
    SDL_mixer
    SDL_ttf
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-c++11-narrowing";

  meta = {
    description = "GNU Ball and Paddle, an old-fashioned ball and paddle game";
    longDescription = ''
      GNU Ball and Paddle is an old-fashioned ball and paddle game
      with a set amount of blocks to destroy on each level, while
      moving a paddle left and right at the bottom of the
      screen.  Various powerups may make different things occur.

      It now uses GNU Guile for extension and the levels are written
      with Guile.  Follow the example level sets and the documentation.
    '';
    homepage = "https://www.gnu.org/software/ballandpaddle/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.wegank ];
    platforms = lib.platforms.unix;
    hydraPlatforms = lib.platforms.linux; # sdl-config times out on darwin
  };
}
