{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "custom-sidebar";
  version = "10.3.0";

  src = fetchFromGitHub {
    owner = "elchininet";
    repo = "custom-sidebar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uono4z8jd+OwxNnBl4Ge9g3YbLAprNrmFJPh7rKsvSM=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZWh2R6wr7FH2RfoFAE81Kl+wHnUeNjUbFG3KIk8ZN3g=";
  };

  nativeBuildInputs = [
    pnpm.configHook
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

  meta = with lib; {
    description = "Custom plugin that allows you to personalise the Home Assistant's sidebar per user or device basis";
    homepage = "https://elchininet.github.io/custom-sidebar";
    downloadPage = "https://github.com/elchininet/custom-sidebar";
    changelog = "https://github.com/elchininet/custom-sidebar/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ kranzes ];
  };
})
