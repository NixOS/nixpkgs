{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "toothbrush-card";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "mtheli";
    repo = "toothbrush-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w2+s41KRQQtHYmoePyX1sILlLYioPv5AT+ivVWg7hl0=";
  };

  npmDepsHash = "sha256-png+Asj6YEXeES400j+LMhfwP0s2FK3AmaOL95czXew=";

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
