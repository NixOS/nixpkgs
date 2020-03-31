{stdenv, fetchgit, cmake, SDL2, SDL2_image, boost, libpng, SDL2_mixer
, pkgconfig, libGLU, libGL, git, jsoncpp }:
stdenv.mkDerivation rec {
  pname = "pingus";
  version = "unstable-0.7.6.0.20191104";

  nativeBuildInputs = [ pkgconfig git ];
  buildInputs = [ cmake SDL2 SDL2_image boost libpng SDL2_mixer libGLU libGL jsoncpp ];
  src = fetchgit {
    url = "https://gitlab.com/pingus/pingus/";
    rev = "709546d9b9c4d6d5f45fc9112b45ac10c7f9417d";
    sha256 = "sha256:11mmzk0766riaw5qyd1r5i7s7vczbbzfccm92bvgrm99iy1sj022";
    fetchSubmodules = true;
  };

  meta = {
    description = ''A puzzle game with mechanics similar to Lemmings'';
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.raskin];
    license = stdenv.lib.licenses.gpl3;
  };
}
