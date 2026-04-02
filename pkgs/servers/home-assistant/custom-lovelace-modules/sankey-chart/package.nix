{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "sankey-chart";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "MindFreeze";
    repo = "ha-sankey-chart";
    rev = "v${version}";
    hash = "sha256-dwviZVfs8CAdawUuaVHYmGWBri+X6r962kX8xiFhzsM=";
  };

  npmDepsHash = "sha256-Kpv43sPc/+1E7TJzzncOBQbV2lVTNIfMC3gYWXDP/6k=";

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
