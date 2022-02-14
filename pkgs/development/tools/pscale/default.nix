{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.89.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-6iExcck9s5Z6c8QA+F+Fnk5g0WNmifaSQa2KaIS9m8M=";
  };

  vendorSha256 = "sha256-kNt7tMHubpcrfzAjf++GxV3kEj2g6fHFrP9cY8UPqB8=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
