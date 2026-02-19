{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  nix-update-script,
}:

let
  pnpm = pnpm_9;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "atomic-calendar-revive";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "totaldebug";
    repo = "atomic-calendar-revive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cqtXhBSFuEuh8IH/6S0qZN3+SrdCt0WXrBJlBcDUujY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-fhi1ysI2ygMfPTSiu40tt713fA/dy7r28Xyk0HxSvXE=";
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
