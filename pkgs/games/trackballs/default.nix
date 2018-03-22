{ stdenv, fetchFromGitHub, cmake, SDL2, SDL2_ttf, gettext, zlib, SDL2_mixer, SDL2_image, guile, libGLU_combined }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "trackballs-${version}";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "trackballs";
    repo = "trackballs";
    rev = "v${version}";
    sha256 = "0y5y8xzfsjd0rxl5wnxdq7m9n97s5xvcqyjsckz4qxrjcc3lk297";
  };

  buildInputs = [ cmake zlib SDL2 SDL2_ttf SDL2_mixer SDL2_image guile gettext libGLU_combined ];

  meta = {
    homepage = https://trackballs.github.io/;
    description = "3D Marble Madness clone";
    platforms = stdenv.lib.platforms.linux;
  };
}
