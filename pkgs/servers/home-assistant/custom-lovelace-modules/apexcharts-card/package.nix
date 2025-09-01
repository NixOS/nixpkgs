{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "apexcharts-card";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "RomRider";
    repo = "apexcharts-card";
    rev = "v${version}";
    hash = "sha256-r8PjZLUWnC25XsA4CI1qCX5Np2HY6kp1sWSqfXfJrPk=";
  };

  npmDepsHash = "sha256-w/TR+8Oo6dbSnlHKhKKVSpeDops4WoGdle6VTCyR7T4=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lovelace card to display advanced graphs and charts based on ApexChartsJS for Home Assistant";
    homepage = "https://github.com/RomRider/apexcharts-card";
    changelog = "https://github.com/RomRider/apexcharts-card/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.all;
  };
}
