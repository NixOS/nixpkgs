{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "icingaweb2-theme-spring";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KU58zxush7n5KHACUpHkhaKyVHOp9qtFhVk1e8NBZCc=";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Theme with some soft colors and nice background images loaded from unsplash.com";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-spring";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
