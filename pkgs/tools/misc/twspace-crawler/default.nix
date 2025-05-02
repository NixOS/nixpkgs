{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.9";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "7875e534b257d4ba5a0cf8179a4772c87005fee6"; # version not tagged
    hash = "sha256-pA31ak0Rwy4Rc1fVz+4QV1lcTYGUmPOd61FtLQGN1ek=";
  };

  npmDepsHash = "sha256-2fsYeSZYzadLmikUJbuHE4XMAp38jTZvtRo9xgaZVzg=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ ];
    mainProgram = "twspace-crawler";
  };
}
