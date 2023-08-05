{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.7";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "bc1626996076f4e73890dc80b2fe99d578a7c641"; # version not tagged
    hash = "sha256-/2wdl7VCcO8WRAYFtr1wtu80TwyLI3Hi8XzmrzOzhUQ=";
  };

  npmDepsHash = "sha256-pPpUQ6o0P7iTcdLwWqwItJFVhYH9rC+bLKo4Gz7DiRE=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
