{ lib, callPackage, fetchFromGitHub, fetchYarnDeps, mkYarnPackage }:
let
  common = callPackage ./common.nix { };
in
mkYarnPackage {
  pname = "woodpecker-frontend";
  inherit (common) version;

  src = "${common.src}/web";

  packageJSON = ./woodpecker-package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = "${common.src}/web/yarn.lock";
    hash = common.yarnHash;
  };

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R deps/woodpecker-ci/dist $out
    echo "${common.version}" > "$out/version"

    runHook postInstall
  '';

  # Do not attempt generating a tarball for woodpecker-frontend again.
  doDist = false;

  meta = common.meta // {
    description = "Woodpecker Continuous Integration server frontend";
  };
}
