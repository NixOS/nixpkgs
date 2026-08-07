{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
}:
let
  pnpm = pnpm_10;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kiosk-mode";
  version = "14.0.2";

  src = fetchFromGitHub {
    owner = "nemesisre";
    repo = "kiosk-mode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fs461HYpxrM8WbPXxLGYY/trD7EVM/GyY7qL4LtRIo8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-0q2yQyUfUWDgiJ/moKsveLC63IrNlV+qsrvVqzUqsVM=";
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

    mkdir -p "$out"
    cp dist/* "$out"

    runHook postInstall
  '';

  meta = {
    description = "Hides the Home Assistant header and/or sidebar";
    homepage = "https://github.com/NemesisRE/kiosk-mode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teeco123 ];
    platforms = lib.platforms.all;
  };
})
