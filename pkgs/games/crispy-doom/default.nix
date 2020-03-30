{ stdenv, autoreconfHook, pkgconfig, SDL2, SDL2_mixer, SDL2_net, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "crispy-doom";
  version = "5.7";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1m9bk7hp3d4sdd3y3isvf26rxya7511mnwyv99l2f80adbsv3nq2";
  };

  postPatch = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];
  enableParallelBuilding = true;

  meta = {
    homepage = "http://fabiangreffrath.github.io/crispy-doom";
    description = "A limit-removing enhanced-resolution Doom source port based on Chocolate Doom";
    longDescription = ''
      Crispy Doom is a limit-removing enhanced-resolution Doom source port based on Chocolate Doom.
      Its name means that 640x400 looks \"crisp\" and is also a slight reference to its origin.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ neonfuz ];
  };
}
