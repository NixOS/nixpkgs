{
  fetchPnpmDeps,
  lib,
  makeShellWrapper,
  nodejs-slim,
  pnpmConfigHook,
  stdenv,
  testers,

  pnpm,
  pnpmDepsHash,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nixpkgs-pnpm-integration-test";
  inherit (pnpm) version;

  src = ./src;

  pnpmDeps = testers.invalidateFetcherByDrvHash fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = pnpmDepsHash;
  };

  nativeBuildInputs = [
    makeShellWrapper
    nodejs-slim
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/nixpkgs-pnpm-integration-test dist/index.js

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/nixpkgs-pnpm-integration-test \
      --add-flags "$out/lib/nixpkgs-pnpm-integration-test"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-pnpm-integration-test";
    inherit (pnpm.meta) maintainers;
  };
})
