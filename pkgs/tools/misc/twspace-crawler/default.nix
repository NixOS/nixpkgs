{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.11.13";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "v${version}";
    hash = "sha256-MGFVIQDb++oVbTQubl7CNYwT/ofTNFQfFiveXcNgQpA=";
  };

  npmDepsHash = "sha256-zKy/DngBwnfUqG6JfCULoDIrg1V16hX0Q4zNz45z888=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/raw/v${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
