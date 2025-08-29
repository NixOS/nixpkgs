{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "custom-sidebar";
  version = "10.5.1";

  src = fetchFromGitHub {
    owner = "elchininet";
    repo = "custom-sidebar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sDVilhMIMkehKXPz7p2DH6NGn43h0WHpYABUpL3ylrE=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-4928fyjVZ6C4Fyt2+c+cWSOeyCrix2xrhufNrxGZSAU=";
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
