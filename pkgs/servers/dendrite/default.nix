{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "sha256-cEqedl6iVt/HZEh1zeEcqby8gfJEcqIDEQnPewyErMI=";
  };

  vendorSha256 = "sha256-nQx+PyjRvECeIerZ9jq7YMTSS8LfohY7NgK8DklREQQ=";

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
