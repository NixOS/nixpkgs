{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "easy-floorplan";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nicosandller";
    repo = "easy-floorplan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PavhBlVsuCL1cG2zVhiWKUmmsCbj9nEvXXXX8ehlL64=";
  };

  npmDepsHash = "sha256-hY9YRAac/gr2iOQD5ionYKh1mCh4tgXGIpXjFPjcHeE=";

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/easy-floorplan-card.js $out/easy-floorplan.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive Home Assistant floorplan card with a visual drag-and-drop editor";
    homepage = "https://github.com/nicosandller/easy-floorplan";
    changelog = "https://github.com/nicosandller/easy-floorplan/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rhoriguchi ];
    platforms = lib.platforms.all;
  };
})
