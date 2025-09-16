{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "bubble-card";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "Clooos";
    repo = "Bubble-Card";
    rev = "v${version}";
    hash = "sha256-soLeHWDp72C5KzjnkdPVneJrShFVcOHvvVyLPMVpJM0=";
  };

  npmDepsHash = "sha256-NSHsw/+dmdc2+yo4/NgT0YMMrCuL8JjRR6MSJ5xQTiE=";

  preBuild = ''
    rm -rf dist
  '';

  npmBuildScript = "dist";

  installPhase = ''
    runHook preInstall

    cp -rv dist $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/Clooos/bubble-card/releases/tag/v${version}";
    description = "Bubble Card is a minimalist card collection for Home Assistant with a nice pop-up touch";
    homepage = "https://github.com/Clooos/Bubble-Card";
    license = licenses.mit;
    maintainers = with maintainers; [ pta2002 ];
  };
}
