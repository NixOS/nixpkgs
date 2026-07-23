{
  lib,
  stdenv,
  callPackage,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
}:
let
  common = callPackage ./common.nix { };

  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "woodpecker-webui";
  inherit (common) version src;

  sourceRoot = "${common.src.name}/web";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    sourceRoot = "${common.src.name}/web";
    fetcherVersion = 3;
    hash = common.nodeModulesHash;
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = common.meta // {
    description = "Woodpecker Continuous Integration server webui";
  };
})
