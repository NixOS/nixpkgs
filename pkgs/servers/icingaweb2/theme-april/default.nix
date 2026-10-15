{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "icingaweb2-theme-april";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-D7zuq6nbGURC5xpi8CDFVYBc2c4u4XNYfZ/SQ6bQMkQ=";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Icingaweb2 theme for april fools";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-april";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
