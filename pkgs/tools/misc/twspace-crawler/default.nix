{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "d78caf0da5eb9c493e3d4d8b4ca47d434f4764bb"; # version not tagged
    hash = "sha256-ONgPGlLRi0z2V1hB15w75GUt2Asc3hrRjuEjNSZc7Bc=";
  };

  npmDepsHash = "sha256-Gq1OWJlIIIOHoP0TMscaPXaVpmfexax2EjdTCDPmeQQ=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
