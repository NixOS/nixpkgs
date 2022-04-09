{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "sha256-R0xGsngNk8osBh3vRUeYxmEgbbNa+wKOihRjOU40D48=";
  };

  vendorSha256 = "sha256-0Y/RVRWZ0osU/kEcf+Y8TH8K2rmxFmQSqMMNHoRIugo=";

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
