{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "custom-brand-icons";
  version = "2026.09.0";

  src = fetchFromGitHub {
    owner = "elax46";
    repo = "custom-brand-icons";
    tag = finalAttrs.version;
    hash = "sha256-khX+OqeAN45kFAhMOOq3k4N/FtkS//p+1LaskDL3so8=";
  };

  npmDepsHash = "sha256-SP7tmazutPJWx8Pj9NU30ErNARvsnizONNek8q3DCR4=";

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
