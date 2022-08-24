{ lib
, callPackage
, fetchFromGitHub
, fetchYarnDeps
, mkYarnPackage }:
let
  common = callPackage ./common.nix { };
in
mkYarnPackage {
  inherit (common) version;
  pname = "pomerium-ui";
  src = "${common.src}/ui";

  # update pomerium-ui-package.json when updating package, sourced from ui/package.json
  packageJSON = ./pomerium-ui-package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${common.src}/ui/yarn.lock";
    sha256 = common.yarnSha256;
  };

  buildPhase = ''
    runHook preBuild
    yarn --offline build
    runHook postbuild
  '';

  installPhase = ''
    runHook preInstall
    cp -R deps/pomerium/dist $out
    runHook postInstall
  '';

  doDist = false;

  meta = common.meta // {
    description = "Pomerium authenticating reverse proxy UI";
  };
}
