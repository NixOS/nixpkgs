{ lib, mkDerivation, fetchFromGitHub, fetchpatch, pkg-config, qmake
, SDL2, fluidsynth, libsndfile, libvorbis, mpg123, qtbase
}:

mkDerivation rec {
  pname = "qtads";
<<<<<<< HEAD
  version = "3.4.0";
=======
  version = "3.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "realnc";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-KIqufpvl7zeUtDBXUOAZxBIbfv+s51DoSaZr3jol+bw=";
=======
    sha256 = "sha256-CndN8l7GGIekfbz7OrTYIElL7SxRxEkiNiZP2NHuxOg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config qmake ];

  buildInputs = [ SDL2 fluidsynth libsndfile libvorbis mpg123 qtbase ];

  meta = with lib; {
    homepage = "https://realnc.github.io/qtads/";
    description = "Multimedia interpreter for TADS games";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
