{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, zlib, libpng, libjpeg, libwebp, libGLU, libGL, glm
, libX11, libXext, libXfixes, libXrandr, libXcomposite, slop, icu
}:

stdenv.mkDerivation rec {
  pname = "maim";
  version = "5.7.4";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "maim";
    rev = "v${version}";
    sha256 = "sha256-uFtiwaM3H09vfvz3wVvumbqkoZhLNJxONkMqqqrJBs4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ zlib libpng libjpeg libwebp libGLU libGL glm
      libX11 libXext libXfixes libXrandr libXcomposite slop icu ];

  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A command-line screenshot utility";
    longDescription = ''
      maim (make image) takes screenshots of your desktop. It has options to
      take only a region, and relies on slop to query for regions. maim is
      supposed to be an improved scrot.
    '';
    changelog = "https://github.com/naelstrof/maim/releases/tag/v${version}";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
