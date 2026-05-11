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
  pname = "custom-sidebar";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "elchininet";
    repo = "custom-sidebar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2CQcY5/Cb3IPuI7cL28t7iZCH3kD21equBW5BL6w8TU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-gYNCjCeAt6LP4tZE4ufiQu7OG2ujWydm4etcGQxMxcU=";
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

  passthru.entrypoint = "custom-sidebar-yaml.js";

  meta = {
    description = "Custom plugin that allows you to personalise the Home Assistant's sidebar per user or device basis";
    homepage = "https://elchininet.github.io/custom-sidebar";
    downloadPage = "https://github.com/elchininet/custom-sidebar";
    changelog = "https://github.com/elchininet/custom-sidebar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
