{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "bubble-card";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "Clooos";
    repo = "Bubble-Card";
    rev = "v${version}";
    hash = "sha256-8sSYqrcfWwnxJ0QGrPdjtAj2FG1TGINIgrvgqFncrIU=";
  };

  npmDepsHash = "sha256-zkZfyNeJgk0eQkMVptuH7iN5/J/EicGeYHTAF09gLM4=";

  preBuild = ''
    rm -rf dist
  '';

  npmBuildScript = "dist";

  installPhase = ''
    runHook preInstall

    cp -rv dist $out

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/Clooos/bubble-card/releases/tag/v${version}";
    description = "Bubble Card is a minimalist card collection for Home Assistant with a nice pop-up touch";
    homepage = "https://github.com/Clooos/Bubble-Card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pta2002 ];
  };
}
