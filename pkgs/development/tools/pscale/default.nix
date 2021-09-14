{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-SAKbz33Fpi3sQcqwD2UK5wloJqNs2HohsiGMl1gkfA0=";
  };

  vendorSha256 = "sha256-dEkCJe6qiyB/pNh78o2/TTRmWQDsUV2TsXiuchC1JLA=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
