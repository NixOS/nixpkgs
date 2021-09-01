{ fetchurl, lib, stdenv, SDL, SDL_image, SDL_mixer, SDL_ttf, guile, gettext }:

stdenv.mkDerivation rec {
  pname = "ballandpaddle";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://gnu/ballandpaddle/ballandpaddle-${version}.tar.gz";
    sha256 = "0zgpydad0mj7fbkippw3n9hlda6nac084dq5xfbsks9jn1xd30ny";
  };

  buildInputs = [ SDL SDL_image SDL_mixer SDL_ttf guile gettext ];

  patches = [ ./getenv-decl.patch ];

  preConfigure = ''
    sed -i "Makefile.in" \
        -e "s|desktopdir *=.*$|desktopdir = $out/share/applications|g ;
            s|pixmapsdir *=.*$|pixmapsdir = $out/share/pixmaps|g"
  '';

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

    license = lib.licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/ballandpaddle/";

    maintainers = [ ];

    platforms = lib.platforms.unix;

    hydraPlatforms = lib.platforms.linux; # sdl-config times out on darwin
  };
}
