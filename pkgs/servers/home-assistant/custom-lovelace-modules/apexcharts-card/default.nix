{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "apexcharts-card";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "RomRider";
    repo = "apexcharts-card";
    rev = "v${version}";
    hash = "sha256-bB/FCNVBK8vOfT3q9+qNssNJCtiN7ReqrsJoobf5dpU=";
  };

  npmDepsHash = "sha256-vT5/9/cHkUidqxQdoJK4U7mzuk8w/ryEaqKPxy5MNcY=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Lovelace card to display advanced graphs and charts based on ApexChartsJS for Home Assistant";
    homepage = "https://github.com/RomRider/apexcharts-card";
    changelog = "https://github.com/RomRider/apexcharts-card/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.all;
  };
}
