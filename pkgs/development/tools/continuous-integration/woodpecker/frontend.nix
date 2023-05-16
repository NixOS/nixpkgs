<<<<<<< HEAD
{ lib, buildPackages, callPackage, fetchFromGitHub, fetchYarnDeps, mkYarnPackage }:
let
  common = callPackage ./common.nix { };

  esbuild_0_17_19 = buildPackages.esbuild.overrideAttrs (_: rec {
    version = "0.17.19";

    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      hash = "sha256-PLC7OJLSOiDq4OjvrdfCawZPfbfuZix4Waopzrj8qsU=";
    };

    vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
  });
=======
{ lib, callPackage, fetchFromGitHub, fetchYarnDeps, mkYarnPackage }:
let
  common = callPackage ./common.nix { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
mkYarnPackage {
  pname = "woodpecker-frontend";
  inherit (common) version;

  src = "${common.src}/web";

  packageJSON = ./woodpecker-package.json;
<<<<<<< HEAD
  yarnLock = ./yarn.lock;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = common.yarnHash;
  };

  ESBUILD_BINARY_PATH = lib.getExe esbuild_0_17_19;

  buildPhase = ''
    runHook preBuild

    yarn --offline build
=======
  offlineCache = fetchYarnDeps {
    yarnLock = "${common.src}/web/yarn.lock";
    sha256 = common.yarnSha256;
  };

  buildPhase = ''
    runHook preBuild

    yarn build
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
