{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "weather-radar-card";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "jpettitt";
    repo = "weather-radar-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RbaHls0pvsFZppNX8EtFluNZ7QUnWdapuECCAHM/oLU=";
  };

  postPatch = ''
    substituteInPlace src/radar-toolbar.ts \
      --replace-fail "/local/community/weather-radar-card/" "/local/nixos-lovelace-modules/"
  '';

  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-6zs7AflM9ZqXXK2Tvm+1R8W+Ejyg7k7Tc8IpG4/3vFA=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r dist/* $out/

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
