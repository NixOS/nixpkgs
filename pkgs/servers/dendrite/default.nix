{ lib, stdenv, buildGoModule, fetchFromGitHub
, nixosTests, postgresql, postgresqlTestHook }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "sha256-BA+jI5S8pDXIWzCelUh8pWiXy98E94DJgLvqiy0r23g=";
  };

  vendorSha256 = "sha256-xcgnpaq0owlCD4nA4I1oD8FpsTGziUghRFy/7ZPVpKY=";

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
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
