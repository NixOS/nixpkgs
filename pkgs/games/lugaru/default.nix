{ stdenv, fetchFromGitLab, cmake, openal, pkgconfig, libogg,
  libvorbis, SDL2, makeWrapper, libpng, libjpeg_turbo, libGLU }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "lugaru";
  version = "1.2";

  src = fetchFromGitLab {
    owner = "osslugaru";
    repo = "lugaru";
    rev = version;
    sha256 = "089rblf8xw3c6dq96vnfla6zl8gxcpcbc1bj5jysfpq63hhdpypz";
  };

  nativeBuildInputs = [ makeWrapper cmake pkgconfig ];

  buildInputs = [ libGLU openal SDL2 libogg libvorbis libpng libjpeg_turbo ];

  cmakeFlags = [ "-DSYSTEM_INSTALL=ON" ];

  meta = {
    description = "Lugaru HD: Third person ninja rabbit fighting game";
    homepage = "https://osslugaru.gitlab.io";
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
