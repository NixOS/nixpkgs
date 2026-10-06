{
  fetchPnpmDeps,
  lib,
  makeShellWrapper,
  nodejs-slim,
  pnpmConfigHook,
  pnpm_12,
  stdenv,
  testers,
}:
let
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pnpm-test";
  inherit (pnpm) version;

  src = ./src;

  pnpmDeps = testers.invalidateFetcherByDrvHash fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-NDGKyqZasK13YkmNQ1ypP14rCP8wp2llT8bnKUi4/zo=";
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

    install -Dm644 -t $out/lib/pnpm-12-test dist/index.js

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/pnpm-12-test \
      --add-flags "$out/lib/pnpm-12-test"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "pnpm-12-test";
    inherit (pnpm.meta) maintainers;
  };
})
