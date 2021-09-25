{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.76.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-yfTfWMyRo1QP0QCbJOxNC1eAYmJQ/yKvWjThXd7r7Bc=";
  };

  vendorSha256 = "sha256-dD+8ZraY0RvoGxJZSWG31Iif+R5CDNtQ9H7J8Ty0x7U=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
