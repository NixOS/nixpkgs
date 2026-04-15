{
  lib,
  stdenv,
  fetchFromGitHub,
  gitMinimal,
  yarn-berry_4,
  nodejs,
  npmHooks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "advanced-camera-card";
  version = "7.27.4";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = "advanced-camera-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GHSyDdKGgPPMbcPIqlQbRA0V8gPd1YsId8gqPF0VgTs=";
    leaveDotGit = true; # gitInfo plugin
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    name = "${finalAttrs.pname}-yarn-deps";
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-N5GL9//CS33ntGu8v6i9+S38BDsXDD7HvOask1JflJ8=";
  };

  nativeBuildInputs = [
    gitMinimal
    nodejs
    npmHooks.npmBuildHook
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/dermotduffy/advanced-camera-card/releases/tag/${finalAttrs.src.tag}";
    description = "Comprehensive camera card for Home Assistant";
    homepage = "https://github.com/dermotduffy/advanced-camera-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
