{ stdenv, autoreconfHook, pkgconfig, SDL2, SDL2_mixer, SDL2_net, fetchurl }:

stdenv.mkDerivation rec {
  name = "crispy-doom-5.5.1";
  src = fetchurl {
    url = "https://github.com/fabiangreffrath/crispy-doom/archive/${name}.tar.gz";
    sha256 = "0qnqyyjnclmwls34m7nk8lpvpaffdmhxshlarsiggcsn9py96kns";
  };
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];
  patchPhase = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://fabiangreffrath.github.io/crispy-doom;
    description = "A limit-removing enhanced-resolution Doom source port based on Chocolate Doom";
    longDescription = "Crispy Doom is a limit-removing enhanced-resolution Doom source port based on Chocolate Doom. Its name means that 640x400 looks \"crisp\" and is also a slight reference to its origin.";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ neonfuz ];
  };
}
