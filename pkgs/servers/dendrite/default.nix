{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "sha256-BzQp466Zlp7n56n4SUH4cDRTt8EUWGw3q1dxIBB3TBM=";
  };

  vendorSha256 = "sha256-ak7fWcAXbyVAiyaJZBGMoe2i2nDh4vc/gCC9nbjadJ0=";

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
