{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "1HCVWSxXOR2syN+dLDSvrNzYHTj/vXZRHkXhU0f3m1k=";
  };

  vendorSha256 = "sha256-RqEt0RAsKWKy6NvMzulqY56nZ7fIxgJkgN/WpEZ3F2I=";

  passthru.tests = { inherit (nixosTests) dendrite; };

  meta = with lib; {
    homepage = "https://matrix.org";
    description =
      "Dendrite is a second-generation Matrix homeserver written in Go!";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    platforms = platforms.unix;
  };
}
