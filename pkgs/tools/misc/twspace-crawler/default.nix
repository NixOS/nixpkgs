{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.8";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "3909facc10fe0308d425b609675919e1b9d1b06e"; # version not tagged
    hash = "sha256-qAkrNWy7ofT2klgxU4lbZNfiPvF9gLpgkhaTW1xMcAc=";
  };

  npmDepsHash = "sha256-m0xszerBSx6Ovs/S55lT4CqPRls7aSw4bjONV7BZ8xE=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
