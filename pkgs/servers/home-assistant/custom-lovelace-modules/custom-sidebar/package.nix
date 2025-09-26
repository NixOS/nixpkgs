{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpm,
  nodejs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "custom-sidebar";
  version = "10.5.2";

  src = fetchFromGitHub {
    owner = "elchininet";
    repo = "custom-sidebar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C3zjl4KP2l56Hn7MJjoB8D6KkJ3Ef6KpVZWWdDS5Hds=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-FOaR+B8UammcStvNFo7PR++VCPzY+aXvWeSRXnoPkWM=";
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

  meta = {
    description = "Custom plugin that allows you to personalise the Home Assistant's sidebar per user or device basis";
    homepage = "https://elchininet.github.io/custom-sidebar";
    downloadPage = "https://github.com/elchininet/custom-sidebar";
    changelog = "https://github.com/elchininet/custom-sidebar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
