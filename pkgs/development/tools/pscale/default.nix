{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.72.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-+T1C7qLXSmdpx9uHFK3o4hzaAImd5or/MkE3PB8ZiAs=";
  };

  vendorSha256 = "sha256-7VtDAln/uGalio0pcpqh8XLC0+72dokF+4SmuhPF8AY=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
