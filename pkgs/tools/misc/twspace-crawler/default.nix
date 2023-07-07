{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "8d325a1c8b811c62d971bc3d43cc1553d621f836"; # version not tagged
    hash = "sha256-iV+M+x81j+djlCsAGDIG1V+Psrl1dYIv/ZL1EHfcXVs=";
  };

  npmDepsHash = "sha256-vzSjcsxsEXyPjPAjJWckrKS6/wi17ZOZkDk5FDY7ZeI=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
