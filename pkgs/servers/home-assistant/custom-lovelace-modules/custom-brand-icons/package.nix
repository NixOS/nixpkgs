{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "custom-brand-icons";
  version = "2026.10.1";

  src = fetchFromGitHub {
    owner = "elax46";
    repo = "custom-brand-icons";
    tag = finalAttrs.version;
    hash = "sha256-shGPEqQCzgki/eFSP6aCT1XvAN3jCF+9ljI+9Fm9zXw=";
  };

  npmDepsHash = "sha256-RIEX7kEpoMEEuESXJASHlKMVY+L+2n/JRWvoRbSEPjM=";

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
