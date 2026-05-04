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
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "nemesisre";
    repo = "kiosk-mode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aAZkqTSzH3JXLhp7QGfTYLTMLCe2TrqvonPQrVyeC7w=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-aubBpCupXGemYmeO+Sao9nsUtCm01M7fALbpd4qe7cA=";
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
