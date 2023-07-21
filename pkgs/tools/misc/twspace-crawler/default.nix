{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "twspace-crawler";
  version = "1.12.4";

  src = fetchFromGitHub {
    owner = "HitomaruKonpaku";
    repo = "twspace-crawler";
    rev = "339972a785a4074880a66be4ca4063e6b47ddfaa"; # version not tagged
    hash = "sha256-YJXvBKvZ/Z1mRf6MW3JFqlK77+N+JM3OZZNSJyaaic4=";
  };

  npmDepsHash = "sha256-eVh+1pBAxB+tgS6b8Bd3gtxUK887djbZVVC4wM/5zZk=";

  meta = with lib; {
    description = "Script to monitor & download Twitter Spaces 24/7";
    homepage = "https://github.com/HitomaruKonpaku/twspace-crawler";
    changelog = "https://github.com/HitomaruKonpaku/twspace-crawler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
