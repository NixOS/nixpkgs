{ lib, stdenv
, cairo
, cmake
, fetchFromGitHub
, ffmpeg
, gettext
, libGLU, libGL
, openal
, pkg-config
, SDL2
, sfml
, zip
, zlib
}:

stdenv.mkDerivation rec {
  pname = "visualboyadvance-m";
  version = "2.1.4";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "v${version}";
    sha256 = "1kgpbvng3c12ws0dy92zc0azd94h0i3j4vm7b67zc8mi3pqsppdg";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    cairo
    ffmpeg
    gettext
    libGLU libGL
    openal
    SDL2
    sfml
    zip
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DENABLE_FFMPEG='true'"
    "-DENABLE_LINK='true'"
    "-DSYSCONFDIR=etc"
    "-DENABLE_WX='false'"
    "-DENABLE_SDL='true'"
  ];

  meta =  with lib; {
    description = "A merge of the original Visual Boy Advance forks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lassulus ];
    homepage = "https://vba-m.com/";
    platforms = lib.platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
