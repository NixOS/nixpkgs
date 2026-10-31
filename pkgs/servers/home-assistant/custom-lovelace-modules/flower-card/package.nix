{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "flower-card";
  version = "2026.10.0";

  src = fetchFromGitHub {
    owner = "olen";
    repo = "lovelace-flower-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H+ux8OFf0ko6Kp5fRd/fY9O0P3X2E0ncumlZH5XMhTo=";
  };

  npmDepsHash = "sha256-TlUO6iXev2MnFLyR06OErnlhCNgYQT4cTh1I6N4vmmI=";

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
