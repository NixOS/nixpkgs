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
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "nemesisre";
    repo = "kiosk-mode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y8ck4Y8tmZkUv35n78u+PRc+i6wF6iuhYbQJ7wQPVqE=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-4pTI5d1Mn/GtbjkOAyemxXN2k2rRj8kYS4t2C6OLVSc=";
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
