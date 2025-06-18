{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2-ipl";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-library";
    rev = "v${version}";
    hash = "sha256-1hq7jPe8WiCPAfz7j273BCBWsX1xLVp85vhTEV+2D/E=";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  passthru.tests = { inherit (nixosTests) icingaweb2; };

  meta = {
    description = "PHP library package for Icingaweb 2";
    homepage = "https://github.com/Icinga/icinga-php-library";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    teams = [ lib.teams.helsinki-systems ];
  };
}
