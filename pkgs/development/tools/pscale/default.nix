{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pscale";
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-hrWSieWeVAg28f3Fh9mElr+mDh4v4T5JI1c3+Hrm7c0=";
  };

  vendorSha256 = "sha256-h4YUQWmFYouEvHup8Pu6OqfHf1EoPszVFzklU9SbJZQ=";

  meta = with lib; {
    homepage = "https://www.planetscale.com/";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    description = "The CLI for PlanetScale Database";
    license = licenses.asl20;
    maintainers = with maintainers; [ pimeys ];
  };
}
