{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.85.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-I2t5tuBlO2RpY8+zWSTIDOziriqE6PGKVIwPdmvXuKo=";
  };

  vendorSha256 = "sha256-V7iXPM2WTR5zls/EFxpoLKrconP88om6y2CFNiuS6g4=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
