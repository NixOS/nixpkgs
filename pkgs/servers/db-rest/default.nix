{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_18,
  nix-update-script,
  fetchpatch,
  nixosTests,
}:
buildNpmPackage rec {
  pname = "db-rest";
  version = "6.0.5";

  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "derhuerst";
    repo = pname;
    rev = version;
    hash = "sha256-jMHqJ1whGPz2ti7gn8SPz6o7Fm4oMF6hYjB4wsjKAEU=";
  };

  npmDepsHash = "sha256-rXBIpar5L6fGpDlphr1PqRNxARSccV7Gi+uTNlCqh7I=";

  preConfigure = ''
    patchShebangs ./build/index.js
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = {
    inherit (nixosTests) db-rest;
  };

  meta = {
    description = "A clean REST API wrapping around the Deutsche Bahn API";
    homepage = "https://v6.db.transport.rest/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "db-rest";
  };
}
