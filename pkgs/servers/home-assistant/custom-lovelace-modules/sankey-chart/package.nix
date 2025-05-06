{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "sankey-chart";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "MindFreeze";
    repo = "ha-sankey-chart";
    rev = "v${version}";
    hash = "sha256-krWK2P7tjK5loFYXZ5+b8UN4TEKPObW2QK+3l7+zvj0=";
  };

  npmDepsHash = "sha256-OBgmmPcwpMxXrytP2tHzCFe1imz1S6LHBWJkruw3jgI=";

  installPhase = ''
    runHook preInstall

    mkdir $out/
    cp -v dist/ha-sankey-chart.js $out/sankey-chart.js

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant lovelace card to display a sankey chart.";
    homepage = "https://github.com/MindFreeze/ha-sankey-chart";
    changelog = "https://github.com/MindFreeze/ha-sankey-chart/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
}
