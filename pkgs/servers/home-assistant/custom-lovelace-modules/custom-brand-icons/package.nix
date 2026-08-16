{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "custom-brand-icons";
  version = "2026.08.2";

  src = fetchFromGitHub {
    owner = "elax46";
    repo = "custom-brand-icons";
    tag = finalAttrs.version;
    hash = "sha256-2IiJTwTm7HzUl7/nic5Sask7gflNsxJRnKnlQ7stur8=";
  };

  npmDepsHash = "sha256-+Kn2WQ1MQMKTJ0He/k9NxUpoac9sB61zWRt2wha6c7g=";

  buildPhase = ''
    runHook preBuild

    node custom-icons-builder.cjs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out/
    cp -v dist/custom-brand-icons.js -t $out/

    runHook postInstall
  '';

  meta = {
    description = "Custom brand icons for Home Assistant";
    homepage = "https://github.com/elax46/custom-brand-icons";
    changelog = "https://github.com/elax46/custom-brand-icons/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.all;
  };
})
