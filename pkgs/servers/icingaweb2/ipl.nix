{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2-ipl";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-library";
    tag = "v${version}";
    hash = "sha256-dzrYiZJx7h0gQzXbmp1X3NKlWZAl7hKCEd05+lSRomg=";
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
    maintainers = lib.teams.helsinki-systems.members;
  };
}
