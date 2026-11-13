{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "simple-swipe-card";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nutteloost";
    repo = "simple-swipe-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V1u+XFimwCtKrCD3LcNF7jwszRpYj+nLg2Lx59riHeE=";
  };

  npmDepsHash = "sha256-mvJe3DEZ/8bxy54uHdNLWxF6+Gzim7K4UcJKelD+kT8=";

  # drop the prebuilt bundle checked into the repo, so the build regenerates it
  postPatch = ''
    rm build/simple-swipe-card.js
  '';

  buildPhase = ''
    runHook preBuild

    NODE_ENV=production MINIFY=true npx rollup -c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/simple-swipe-card.js $out/simple-swipe-card.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Swipeable container for multiple cards with touch and mouse gestures";
    homepage = "https://github.com/nutteloost/simple-swipe-card";
    changelog = "https://github.com/nutteloost/simple-swipe-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
