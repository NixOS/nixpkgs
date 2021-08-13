{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-LYVR8vcMS6ErYH4sGRi1JT9E4ElYe5mloc3C1TudzSE=";
  };

  vendorSha256 = "sha256-3LuzdvwLYSL7HaGbKDfrqBz2FV2yr6YUdI5kXXiIvbU=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
