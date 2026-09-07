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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "troinine";
    repo = "ha-weather-forecast-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/i0BUUmiRvH1ZycS8t7yUFeuO9e5SIHlBvWz98tMAZo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-01AGz1k7I/ENOHhk7ycVFftd6yh/3Y9X1+Bc6lJshhU=";
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
