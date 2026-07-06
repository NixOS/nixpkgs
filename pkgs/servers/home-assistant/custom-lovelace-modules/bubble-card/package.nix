{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "bubble-card";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "Clooos";
    repo = "Bubble-Card";
    rev = "v${version}";
    hash = "sha256-sQWpz1GMmX6RRGBI8uzdOrX5taUJUIbz+lE9ChXAvig=";
  };

  npmDepsHash = "sha256-jyw8U99R7M3JJwu30ADefAitm4lWWVHEwq108gWZpfg=";

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
