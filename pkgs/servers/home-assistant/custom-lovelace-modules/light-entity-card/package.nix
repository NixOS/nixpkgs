{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "light-entity-card";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "ljmerza";
    repo = "light-entity-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7nRONIGy7kOYJBx813f7luwMI1rDu9FR75OP5HBsDxY=";
  };

  npmDepsHash = "sha256-askNG1clZXaJbRBJH7HG/JGhxejmBq38py+A6sSmM3w=";

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
