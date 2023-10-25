{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.6";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "fc415f4b889f93bdbf357e14f1a6bf3fc146aac9"; # version not tagged
    hash = "sha256-25/VFbf6UJJKnDDCXuIfWSEgVD24SB3feLV0zF8DlBs=";
  };

  npmDepsHash = "sha256-4ZNFuOCdCh+H8tH8qKr2569wDFPOxaLfqmA6N3FNP84=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
