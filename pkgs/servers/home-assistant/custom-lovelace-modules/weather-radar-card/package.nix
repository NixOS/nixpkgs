{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "weather-radar-card";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "jpettitt";
    repo = "weather-radar-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-94fag6+i+9otVQRAllZA0dSyC0MGhv0Q6brEavWMs8k=";
  };

  postPatch = ''
    substituteInPlace src/radar-toolbar.ts \
      --replace-fail "/local/community/weather-radar-card/" "/local/nixos-lovelace-modules/"
  '';

  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-pYvnYYgmm4+2fOO/pLR+OtlKfBKf2Xws6Oz8mEOSNPM=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    shopt -s extglob
    cp -r dist/!(*.gz) $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Rrain radar card using the tiled images from RainViewer";
    homepage = "https://github.com/jpettitt/weather-radar-card";
    changelog = "https://github.com/jpettitt/weather-radar-card/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.linux;
  };
})
