{ stdenv, fetchurl, SDL, SDL_image, SDL_mixer }:

stdenv.mkDerivation rec {
  pname = "gnujump";
  version = "1.0.8";
  src = fetchurl {
    url = "mirror://gnu/gnujump/${pname}-${version}.tar.gz";
    sha256 = "05syy9mzbyqcfnm0hrswlmhwlwx54f0l6zhcaq8c1c0f8dgzxhqk";
  };
  buildInputs = [ SDL SDL_image SDL_mixer ];

  NIX_LDFLAGS = "-lm";

  meta = with stdenv.lib; {
    homepage = https://jump.gnu.sinusoid.es/index.php?title=Main_Page;
    description = "A clone of the simple yet addictive game Xjump";
    longDescription = ''
      The goal in this game is to jump to the next floor trying not to fall
      down. As you go upper in the Falling Tower the floors will fall faster.
      Try to survive longer get upper than anyone. It might seem too simple but
      once you've tried you'll realize how addictive this is.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}
