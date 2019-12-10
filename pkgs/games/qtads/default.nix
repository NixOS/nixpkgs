{ lib, stdenv, fetchFromGitHub, fetchpatch, pkgconfig, qmake
, SDL2, fluidsynth, libsndfile, libvorbis, mpg123, qtbase
}:

stdenv.mkDerivation rec {
  pname = "qtads";
  version = "2.1.99.2019-04-12";

  src = fetchFromGitHub {
    owner = "realnc";
    repo = pname;
    rev = "43289a830a18c66a293c2b1ee75a08e92e8dd5dc";
    sha256 = "0zscf6nmjjc4i7c38iy8znv2s453xc49gn7knyi3g1l6iinjwbx7";
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
