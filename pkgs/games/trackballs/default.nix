{ stdenv, fetchFromGitHub, cmake, SDL2, SDL2_ttf, gettext, zlib, SDL2_mixer, SDL2_image, guile, libGLU, libGL }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "trackballs";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "trackballs";
    repo = "trackballs";
    rev = "v${version}";
    sha256 = "1yjzz50r57aahy7wcbsmhrd40abzyriq40j49225ya7m9g28vmgl";
  };

  buildInputs = [ cmake zlib SDL2 SDL2_ttf SDL2_mixer SDL2_image guile gettext libGLU libGL ];

  meta = {
    homepage = https://trackballs.github.io/;
    description = "3D Marble Madness clone";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
