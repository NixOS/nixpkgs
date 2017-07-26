{ stdenv, fetchFromGitHub, cmake, pkgconfig
, zlib, libpng, libjpeg
, mesa, glm, libX11, libXext, libXfixes, libXrandr, libXcomposite, slop }:

stdenv.mkDerivation rec {
  name = "maim-${version}";
  version = "5.4.64";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "maim";
    rev = "v${version}";
    sha256 = "16ipqs4s5hn7a7380n8w1ijj26d9n356bqwl1h8z5i1skbj4w7hj";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs =
    [ zlib libpng libjpeg mesa glm libX11 libXext libXfixes libXrandr
      libXcomposite slop ];

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
