{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "sha256-F2e+peM7DBihmos/oPar36UDHkibmlzIknCjMauOph8=";
  };

  vendorSha256 = "sha256-M6mnFO+SInZNvtwMa02TvHIg14Ve7swlGcYfsQFioxQ=";

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
