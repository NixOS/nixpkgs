{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.58.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-9XVvdAt/TWQdCY8s//QHZC6THFAf+pMYQpjHjUR3wrc=";
  };

  vendorSha256 = "sha256-m6eQ843aP68TO4W5Nq4zKqcf2wgdH/7Srzt37t/NSdk=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
