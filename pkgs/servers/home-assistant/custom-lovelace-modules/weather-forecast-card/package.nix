{
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm,
  pnpmConfigHook,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "weather-forecast-card";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "troinine";
    repo = "ha-weather-forecast-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N3bE6HSXx6Vst6ZiMsJ490XBnlDQJDm+MoEunlLusnQ=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-DDJpfkblo3E6YxWThs0rtkMabhRuDW2k5fszTo4Gud8=";
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

  passthru.entrypoint = "weather-forecast-card.js";

  meta = {
    description = "Slightly improved weather forecast card for Home Assistant";
    homepage = "https://github.com/troinine/ha-weather-forecast-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
