{ stdenv, fetchFromGitHub, cmake, pkgconfig
, zlib, libpng, libjpeg, libGLU_combined, glm
, libX11, libXext, libXfixes, libXrandr, libXcomposite, slop, icu
}:

stdenv.mkDerivation rec {
  name = "maim-${version}";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "maim";
    rev = "v${version}";
    sha256 = "14mfxdm39kc5jk8wysrzx05ag2g4sk9l24i8m5pzqn8j611150v3";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs =
    [ zlib libpng libjpeg libGLU_combined glm
      libX11 libXext libXfixes libXrandr libXcomposite slop icu ];

  doCheck = false;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A command-line screenshot utility";
    longDescription = ''
      maim (make image) takes screenshots of your desktop. It has options to
      take only a region, and relies on slop to query for regions. maim is
      supposed to be an improved scrot.
    '';
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ primeos mbakke ];
  };
}
