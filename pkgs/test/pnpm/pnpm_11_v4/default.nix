{
  fetchPnpmDeps,
  lib,
  makeShellWrapper,
  nodejs-slim,
  pnpmConfigHook,
  pnpm_11,
  stdenv,
  testers,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pnpm-test";
  inherit (pnpm) version;

  src = ./src;

  pnpmDeps = testers.invalidateFetcherByDrvHash fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-f5EC0m+y9vvt+6alquFjdgGmH8ha1YprthBU3dnq9SE=";
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

    install -Dm644 -t $out/lib/pnpm-11-test dist/index.js

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/pnpm-11-test \
      --add-flags "$out/lib/pnpm-11-test"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "pnpm-11-test";
    inherit (pnpm.meta) maintainers;
  };
})
