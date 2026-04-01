{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2-thirdparty";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-thirdparty";
    rev = "v${version}";
    sha256 = "sha256-5dcAH4mBUF6QUd7nL9GhPjHqMfIpuslTIfdmHKNEk/A=";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  passthru.tests = { inherit (nixosTests) icingaweb2; };

  meta = {
    description = "Third party dependencies for Icingaweb 2";
    homepage = "https://github.com/Icinga/icinga-php-thirdparty";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
    ];
  };
}
