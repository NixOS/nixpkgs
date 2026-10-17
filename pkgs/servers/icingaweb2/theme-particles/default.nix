{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "icingaweb2-theme-particles";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Mikesch-mp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3m0R7+olCXw+/2PJVEL0jNTGPthoLiwbmQaZkMJfy1Q=";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "This theme adds a nice particle effect to the login screen of Icingaweb 2";
    homepage = "https://github.com/Mikesch-mp/icingaweb2-theme-particles";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
