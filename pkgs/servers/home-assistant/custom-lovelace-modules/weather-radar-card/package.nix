{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "weather-radar-card";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "jpettitt";
    repo = "weather-radar-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NvxkVEuXrVO95qR7YBU1WSdZXTlHsOkVB39ZGwis/lw=";
  };

  postPatch = ''
    substituteInPlace src/radar-toolbar.ts \
      --replace-fail "/local/community/weather-radar-card/" "/local/nixos-lovelace-modules/"
  '';

  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-/PU0e4A5RH7g5jE0+Ai2y4MvOa6D2+7G+wcsv18orYk=";

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
