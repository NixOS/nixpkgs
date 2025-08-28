{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "apexcharts-card";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "RomRider";
    repo = "apexcharts-card";
    rev = "v${version}";
    hash = "sha256-wHQmbNX96X4YT0xvLp13scD0c7MAADP4Ax47fwYRgbM=";
  };

  npmDepsHash = "sha256-5hCd/ksFSIOsNZfVr5aoun7qrtkIlAGvwQN1xr6AbMI=";

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
