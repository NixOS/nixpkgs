{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "21d305a63e7d70c5fd441ae80e4908383655508a"; # version not tagged
    hash = "sha256-VVA3Yer+2TdDlevOfYVi3plXiZd7TA1/ijPp2WfjNPo=";
  };

  npmDepsHash = "sha256-6AsHmEoKSZBjTA2JUeu9A/ZDl914yDw7ePes/GKclw8=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
