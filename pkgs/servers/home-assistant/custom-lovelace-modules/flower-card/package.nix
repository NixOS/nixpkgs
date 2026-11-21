{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "flower-card";
  version = "2026.11.3";

  src = fetchFromGitHub {
    owner = "olen";
    repo = "lovelace-flower-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8ovGUlshUNHuY5uUd4iN47JwrKSrLSisStNxjHUKq4k=";
  };

  npmDepsHash = "sha256-o/kKWJ4nLxezC5L6ismfQlolVtwoYF2Lim8h5wGLHO4=";

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
