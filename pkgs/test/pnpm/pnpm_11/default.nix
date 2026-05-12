{
  fetchPnpmDeps,
  lib,
  makeShellWrapper,
  nodejs,
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
    fetcherVersion = 3;
    hash = "sha256-+Vrv5ZiVIARDZrR5/4OYRmaecQQZmcZFtMjK4qhXKb8=";
  };

  nativeBuildInputs = [
    makeShellWrapper
    nodejs
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

    makeWrapper ${lib.getExe nodejs} $out/bin/pnpm11test \
      --add-flags "$out/lib/pnpm11test"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "pnpm11test";
    inherit (pnpm.meta) maintainers;
  };
})
