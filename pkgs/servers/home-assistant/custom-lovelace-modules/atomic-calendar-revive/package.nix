{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  nix-update-script,
}:

let
  pnpm = pnpm_11;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "atomic-calendar-revive";
  version = "10.3.1";

  src = fetchFromGitHub {
    owner = "totaldebug";
    repo = "atomic-calendar-revive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qqEQrbLQU5zhMcDDtg5f9Py4raOSYKCy4uv2omK6eO8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-yxB142cM4Qe3bzs5ZHD+Bfi+AEoBdq5n2K2Mmm0nIhs=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./dist/atomic-calendar-revive.js $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/totaldebug/atomic-calendar-revive/releases/tag/v${finalAttrs.version}";
    description = "Advanced calendar card for Home Assistant Lovelace";
    homepage = "https://github.com/totaldebug/atomic-calendar-revive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
})
