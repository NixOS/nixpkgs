{ lib, stdenv, fetchFromGitLab, cmake, openal, pkg-config, libogg,
  libvorbis, SDL2, makeWrapper, libpng, libjpeg_turbo, libGLU }:

stdenv.mkDerivation rec {

  pname = "lugaru";
  version = "1.2";

  src = fetchFromGitLab {
    owner = "osslugaru";
    repo = "lugaru";
    rev = version;
    sha256 = "089rblf8xw3c6dq96vnfla6zl8gxcpcbc1bj5jysfpq63hhdpypz";
  };

  nativeBuildInputs = [ makeWrapper cmake pkg-config ];

  buildInputs = [ libGLU openal SDL2 libogg libvorbis libpng libjpeg_turbo ];

  cmakeFlags = [ "-DSYSTEM_INSTALL=ON" ];

  meta = {
    description = "Third person ninja rabbit fighting game";
    homepage = "https://osslugaru.gitlab.io";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
