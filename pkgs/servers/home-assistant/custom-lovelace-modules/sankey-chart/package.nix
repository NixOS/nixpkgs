{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "sankey-chart";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "MindFreeze";
    repo = "ha-sankey-chart";
    rev = "v${version}";
    hash = "sha256-qDFCrnx0G+RsDq1V8wvo04AelR82SlXOYqWJntnSBJY=";
  };

  npmDepsHash = "sha256-A4aw4OKBQRsc6O60ewp88QxABANjnNlejSUfcFGyyRA=";

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
