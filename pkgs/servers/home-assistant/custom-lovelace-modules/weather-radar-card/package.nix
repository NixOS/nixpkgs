{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "weather-radar-card";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "jpettitt";
    repo = "weather-radar-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZEd27lt5S7pnGGzTnxLV6voEpzXjvRjubjmusLuISZg=";
  };

  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-S3PZOcKBseohCKOUSRFCQj6fAJTrZLRD5916iB35rrc=";

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
