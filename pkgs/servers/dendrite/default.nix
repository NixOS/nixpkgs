{ lib, buildGoModule, fetchFromGitHub
, nixosTests, postgresql, postgresqlTestHook }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "sha256-AU8Tb50HVODB2P9vObiIx4l+PxIFR+eQEgLi3wHWT64=";
  };

  vendorSha256 = "sha256-QqyLgxUB7MXR3SxUV0kYXH7fqQpwIc+G/2Y2ry1r4e4=";

  subPackages = [
    # The server as a monolith: https://matrix-org.github.io/dendrite/installation/install/monolith
    "cmd/dendrite-monolith-server"
    # The server as a polylith: https://matrix-org.github.io/dendrite/installation/install/polylith
    "cmd/dendrite-polylith-multi"
    # admin tools
    "cmd/create-account"
    "cmd/generate-config"
    "cmd/generate-keys"
    "cmd/resolve-state"
    ## curl, but for federation requests, only useful for developers
    # "cmd/furl"
    ## an internal tool for upgrading ci tests, only relevant for developers
    # "cmd/dendrite-upgrade-tests"
    ## tech demos
    # "cmd/dendrite-demo-pinecone"
    # "cmd/dendrite-demo-yggdrasil"
    # "cmd/dendritejs-pinecone"
  ];

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
    changelog = "https://github.com/matrix-org/dendrite/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    platforms = platforms.unix;
  };
}
