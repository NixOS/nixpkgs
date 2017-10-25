{ stdenv, fetchFromGitHub, cmake, SDL2, SDL2_ttf, gettext, zlib, SDL2_mixer, SDL2_image, guile, mesa }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "trackballs-${version}";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "trackballs";
    repo = "trackballs";
    rev = "v${version}";
    sha256 = "13f28frni7fkalxx4wqvmkzz7ba3d8pic9f9sd2z9wa6gbjs9zrf";
  };

  buildInputs = [ cmake zlib SDL2 SDL2_ttf SDL2_mixer SDL2_image guile gettext mesa ];

  meta = {
    homepage = https://trackballs.github.io/;
    description = "3D Marble Madness clone";
    platforms = stdenv.lib.platforms.linux;
  };
}
