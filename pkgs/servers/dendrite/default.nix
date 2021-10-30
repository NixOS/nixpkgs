{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "iCxfsIOZqPQjY0u2Zw3PCe0IJDczqDjcTUA3U5zXbgM=";
  };

  vendorSha256 = "sha256-XS1B6Nl5zGevxE1SohpoTwT/bXn5udYV5ANVFn7eTyA=";

  passthru.tests = {
    inherit (nixosTests) dendrite;
  };

  meta = with lib; {
    homepage = "https://matrix.org";
    description = "Dendrite is a second-generation Matrix homeserver written in Go!";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    platforms = platforms.unix;
  };
}
