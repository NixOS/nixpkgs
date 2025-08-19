{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "sankey-chart";
  version = "3.9.4";

  src = fetchFromGitHub {
    owner = "MindFreeze";
    repo = "ha-sankey-chart";
    rev = "v${version}";
    hash = "sha256-5G/ji9vt4QIs+zyfdBZwgHTjCDTyX68N0lqfIMVMTN0=";
  };

  npmDepsHash = "sha256-jlnGmdwQu1AZTDVrH7njgq5/UorDceUhJtFqzo/xLfc=";

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
