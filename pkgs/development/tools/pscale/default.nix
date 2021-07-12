{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-ykHwDVwL30uXeCEP4EcM8TPYqZmCDDAUUpfinpYipHE=";
  };

  vendorSha256 = "sha256-3VP2fluQLZs4nWT3O6NmCFxrqKw0/j3ASNxtbXHlZEA=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
