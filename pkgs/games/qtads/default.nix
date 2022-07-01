{ lib, mkDerivation, fetchFromGitHub, fetchpatch, pkg-config, qmake
, SDL2, fluidsynth, libsndfile, libvorbis, mpg123, qtbase
}:

mkDerivation rec {
  pname = "qtads";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "realnc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xMAGbOA+qtwMk5VT5yi//GDzTKtYfGku/Sm4l5smzEs=";
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
