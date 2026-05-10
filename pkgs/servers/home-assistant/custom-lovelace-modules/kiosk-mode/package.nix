{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kiosk-mode";
  version = "13.1.0";

  src = fetchFromGitHub {
    owner = "nemesisre";
    repo = "kiosk-mode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IfVV08WwFovNCgs6d3DOltEzF7Ox0w4B8G237Ma3ayY=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-k7kXZ4yFe3As1IGijrmJfgqrMoO2Yi+PrNapuq8Ow3Y=";
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
