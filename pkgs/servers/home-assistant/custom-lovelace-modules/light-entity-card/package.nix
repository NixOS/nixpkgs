{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "light-entity-card";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "ljmerza";
    repo = "light-entity-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-19P+X59S32kOo+qZ1sh9iFiVT7+jhuYsRrGp/6E0HD4=";
  };

  npmDepsHash = "sha256-Sl2TgA73Wq1n//lqokLC7iHcE1Oqt+ZP6MT+Deidhn0=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v dist/light-entity-card.js* $out/

    runHook postInstall
  '';

  passthru.entrypoint = "light-entity-card.js";

  meta = {
    description = "Control any light or switch entity";
    homepage = "https://github.com/ljmerza/light-entity-card";
    changelog = "https://github.com/ljmerza/light-entity-card/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
})
