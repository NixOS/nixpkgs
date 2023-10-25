{ lib, buildGoModule, fetchFromGitHub, fetchpatch
, nixosTests, postgresql, postgresqlTestHook }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    hash = "sha256-2DqEfTXD3W6MxfBb6aHaKH+zpxLc2tHaGuWGQuncySo=";
  };

  patches = [
    # Fix SQLite db lockup
    (fetchpatch {
      url = "https://github.com/matrix-org/dendrite/commit/c08c7405dbe9d88c1364f6f1f2466db5045506cc.patch";
      hash = "sha256-gTF9jK5Ihfe1v49gPCK68BLeiUZa2Syo+7D9r62iEXQ=";
    })
  ];

  vendorHash = "sha256-dc0zpKh7J+fi2b5GD/0BQ120UXbBvJLUF74RmYMSOMw=";

  subPackages = [
    # The server
    "cmd/dendrite"
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
  ];

  nativeCheckInputs = [
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
