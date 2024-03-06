{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage {
  pname = "immich-cli";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    # Using a fixed commit until upstream has release tags for cli.
    rev = "014adf175ad50a61f92804666940e267ab329064";
    hash = "sha256-MK3Watq5/Zp+rymCIfWxAXSgBPDE13g23uDnW7A5x9g=";
  };

  npmDepsHash = "sha256-ssxOXKE1t/bSb972w/cBeK61IrqPLmx9ODMn6D+2Ezw=";

  postPatch = ''
    cd cli
  '';

  meta = {
    description = "CLI utilities for Immich to help upload images and videos";
    homepage = "https://github.com/immich-app/immich";
    license = lib.licenses.mit;
    mainProgram = "immich";
    maintainers = with lib.maintainers; [ felschr pineapplehunter ];
  };
}
