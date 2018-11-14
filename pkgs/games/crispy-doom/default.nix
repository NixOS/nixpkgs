{ stdenv, autoreconfHook, pkgconfig, SDL2, SDL2_mixer, SDL2_net, fetchurl }:

stdenv.mkDerivation rec {
  name = "crispy-doom-5.3";
  src = fetchurl {
    url = "https://github.com/fabiangreffrath/crispy-doom/archive/${name}.tar.gz";
    sha256 = "1d6pha540rwmnari2yys6bhfhm21aaz7n4p1341n8w14vagwv3ik";
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
