{ lib, buildGoModule, fetchFromGitHub
, nixosTests, postgresql, postgresqlTestHook }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "sha256-Q9HqXy9f2pISFG7peMEzcndIKzNT1Nh1zU1XEUnJ00c=";
  };

  vendorSha256 = "sha256-Wi2Sy9cSKAawjZUFRE8ydRjQx5mcSGcIGSsTWgbVr7s=";

  # some tests are racy, re-enable once upstream has fixed them
  doCheck = false;

  checkInputs = [
    postgresqlTestHook
    postgresql
  ];

  postgresqlTestUserOptions = "LOGIN SUPERUSER";
  preCheck = ''
    export PGUSER=$(whoami)
    # temporarily disable this failing test
    # it passes in upstream CI and requires further investigation
    rm roomserver/internal/input/input_test.go
  '';

  passthru.tests = {
    inherit (nixosTests) dendrite;
  };

  meta = with lib; {
    homepage = "https://matrix-org.github.io/dendrite";
    description = "A second-generation Matrix homeserver written in Go";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    platforms = platforms.unix;
  };
}
