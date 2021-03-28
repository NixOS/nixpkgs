{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_ttf, gettext, zlib, SDL2_mixer, SDL2_image, guile, libGLU, libGL }:

stdenv.mkDerivation rec {
  pname = "trackballs";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "trackballs";
    repo = pname;
    rev = "v${version}";
    sha256 = "G+KfQgqk+iI+Beb/ZRul2ArCBcvwYQ/ftEWzdrtwb18=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib SDL2 SDL2_ttf SDL2_mixer SDL2_image guile gettext libGLU libGL ];

  meta = with lib; {
    homepage = "https://trackballs.github.io/";
    description = "3D Marble Madness clone";
    platforms = platforms.linux;
    # Music is licensed under Ethymonics Free Music License.
    license = licenses.gpl2Plus;
  };
}
