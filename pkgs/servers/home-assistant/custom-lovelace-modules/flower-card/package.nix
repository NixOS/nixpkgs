{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "flower-card";
  version = "2026.11.2";

  src = fetchFromGitHub {
    owner = "olen";
    repo = "lovelace-flower-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4FoAorKenejhwDZuMn7624eYDEbM+bT26Hd//A13loE=";
  };

  npmDepsHash = "sha256-QVVT8Eck46coeDVaCASNr2e4/AmK4iwqPpJO/bPQF+Y=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp flower-card.js $out

    runHook postInstall
  '';

  meta = {
    description = "Lovelace Flower Card to match the custom plant integration";
    homepage = "https://github.com/Olen/lovelace-flower-card";
    changelog = "https://github.com/Olen/lovelace-flower-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
