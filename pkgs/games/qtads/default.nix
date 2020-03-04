{ lib, mkDerivation, fetchFromGitHub, fetchpatch, pkgconfig, qmake
, SDL2, fluidsynth, libsndfile, libvorbis, mpg123, qtbase
}:

mkDerivation rec {
  pname = "qtads";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "realnc";
    repo = pname;
    rev = "v${version}";
    sha256 = "02kk2hs20h9ffhylwms9f8zikmmlrz1nvbrm97gis9iljkyx035c";
  };

  nativeBuildInputs = [ pkgconfig qmake ];

  buildInputs = [ SDL2 fluidsynth libsndfile libvorbis mpg123 qtbase ];

  meta = with lib; {
    homepage = https://realnc.github.io/qtads/;
    description = "Multimedia interpreter for TADS games";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
