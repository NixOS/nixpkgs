{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "my-cards";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "AnthonMS";
    repo = "my-cards";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H67EA8zDGNZ9EK+w3Vgb/0NvTdqxmUL177ggS8D8Cz8=";
  };

  npmDepsHash = "sha256-ia9Z65Pvupt37otSLyj0mNFakg5Cl/huIbso4QYc1NA=";

  # drop the prebuilt bundles checked into the repo, so the build regenerates them
  postPatch = ''
    rm -r dist
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out dist/*.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bundle of custom Lovelace cards: my-slider, my-slider-v2 and my-button";
    homepage = "https://github.com/AnthonMS/my-cards";
    changelog = "https://github.com/AnthonMS/my-cards/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
