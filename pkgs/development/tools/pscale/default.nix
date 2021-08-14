{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-RIyxO2nTysJLdYQvlmhZpS8R2kkwN+XeTlk4Ocbk9C8=";
  };

  vendorSha256 = "sha256-8zgWM5e+aKggGbLoL/Fmy7AuALVlLa74eHBxNGjTSy4=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
