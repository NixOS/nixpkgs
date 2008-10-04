{ fetchurl, stdenv, SDL, SDL_image, SDL_mixer, SDL_ttf, guile, gettext }:

stdenv.mkDerivation rec {
  name = "ballandpaddle-0.8.0";

  src = fetchurl {
    url = "mirror://gnu/ballandpaddle/${name}.tar.gz";
    sha256 = "0m81vvwibisaxrqmzlq6k8r5qxv4hpsq2hi6xjmfm1ffzaayplsh";
  };

  buildInputs = [ SDL SDL_image SDL_mixer SDL_ttf guile gettext ];

  patchPhase = ''
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

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/ballandpaddle/;
  };
}
