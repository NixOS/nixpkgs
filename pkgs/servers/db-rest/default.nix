{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs_18
, nix-update-script
, fetchpatch
}:
buildNpmPackage rec {
  pname = "db-rest";
  version = "6.0.4";

  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "derhuerst";
    repo = pname;
    rev = version;
    hash = "sha256-guiAtPOvU/yqspq+G+mTSIFqBp6Kl0JZBPfjPC+ZM1g=";
  };

  npmDepsHash = "sha256-lJT344HpHJFN3QO6kVAj1NhRFTwS+EVkR0ePbtIguFo=";

  preConfigure = ''
    patchShebangs ./build/index.js
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A clean REST API wrapping around the Deutsche Bahn API";
    homepage = "https://v6.db.transport.rest/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "db-rest";
  };
}
