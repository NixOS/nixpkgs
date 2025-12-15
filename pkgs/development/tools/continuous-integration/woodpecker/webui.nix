{
  lib,
  stdenv,
  callPackage,
  nodejs,
  pnpm,
}:
let
  common = callPackage ./common.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "woodpecker-webui";
  inherit (common) version src;

  sourceRoot = "${common.src.name}/web";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${common.src.name}/web";
    fetcherVersion = 2;
    hash = common.nodeModulesHash;
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
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
