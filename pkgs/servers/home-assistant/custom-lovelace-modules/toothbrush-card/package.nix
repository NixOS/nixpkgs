{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "toothbrush-card";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "mtheli";
    repo = "toothbrush-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ypkuluP8YqnPQXQPf0COoMGLFaEz2/YfWVnldJPTVI=";
  };

  npmDepsHash = "sha256-kZRFsH2Lu16T5zsRYe51nt3Exq3zPHfTtan4IfoNBy4=";

  postPatch = ''
    # do not embed build time
    substituteInPlace scripts/gen_build_info.mjs \
      --replace-fail 'new Date().toISOString()' 'new Date(0).toISOString()'
  '';

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
