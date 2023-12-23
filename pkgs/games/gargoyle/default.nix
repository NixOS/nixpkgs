{ lib, fetchFromGitHub, stdenv, cmake, pkg-config
, SDL2, SDL2_mixer, fmt, freetype, libjpeg_turbo
, qt5, libsndfile
}:

stdenv.mkDerivation rec {
  pname = "gargoyle";
  version = "2023.1";

  allowSubstitutes = false;

  src = fetchFromGitHub {
    owner = "garglk";
    repo = "garglk";
    rev = version;
    sha256 = "sha256-XsN5FXWJb3DSOjipxr/HW9R7QS+7iEaITERTrbGEMwA=";
  };

  nativeBuildInputs = [ cmake qt5.wrapQtAppsHook pkg-config ];

  buildInputs = [
    SDL2 SDL2_mixer fmt freetype libjpeg_turbo qt5.qtbase libsndfile
  ];

  preFixup = ''
    sed 's/\/\//\//g' -i $out/lib/pkgconfig/garglk.pc
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://ccxvii.net/gargoyle/";
    license = licenses.gpl2Plus;
    description = "Interactive fiction interpreter GUI";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
