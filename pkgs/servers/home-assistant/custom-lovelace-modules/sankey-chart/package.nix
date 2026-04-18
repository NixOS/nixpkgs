{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "sankey-chart";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "MindFreeze";
    repo = "ha-sankey-chart";
    rev = "v${version}";
    hash = "sha256-JZ2FtJkkF80ic7Dd9MTwOQKJ2hCfxN3IOQFcaJcXapE=";
  };

  npmDepsHash = "sha256-AN/u8VHDY8FXzqS8bSK//DJnqSj1ML//5q7b5hhNVjw=";

  installPhase = ''
    runHook preInstall

    mkdir $out/
    cp -v dist/ha-sankey-chart.js $out/sankey-chart.js

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant lovelace card to display a sankey chart";
    homepage = "https://github.com/MindFreeze/ha-sankey-chart";
    changelog = "https://github.com/MindFreeze/ha-sankey-chart/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
}
