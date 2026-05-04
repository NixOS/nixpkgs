{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeShellWrapper,
  nodejs,
  pnpmConfigHook,
  pnpm_11,
  stdenv,
}:
let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pnpm11test";
  version = "0-unstable-2026-03-30";

  src = fetchFromGitHub {
    owner = "Scrumplex";
    repo = "pnpm11test";
    rev = "7a8d1364c993646a3806e40e0d00e6731b3d4fa7";
    hash = "sha256-eoxVYsQ/trrliNFvsAPun8cxbetgFQ0lycPoNDwbuls=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-Y53cW0YQyN4saFILawb5vNTpOieELHBtstCYtANHO/g=";
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

    install -Dm644 -t $out/lib/pnpm11test dist/index.js

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
