{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "toothbrush-card";
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "mtheli";
    repo = "toothbrush-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nkB+dWvP4rHovxjzP1+aid2K3qTZYXviXUB/kB4FYNg=";
  };

  npmDepsHash = "sha256-kZRFsH2Lu16T5zsRYe51nt3Exq3zPHfTtan4IfoNBy4=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/toothbrush-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "toothbrush-card.js";

  meta = {
    changelog = "https://github.com/mtheli/toothbrush-card/releases/tag/${finalAttrs.src.tag}";
    description = "Custom Lovelace card for electric toothbrushes supporting Oral-B, Philips Sonicare, Xiaomi and Laifen";
    homepage = "https://github.com/mtheli/toothbrush-card";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
})
