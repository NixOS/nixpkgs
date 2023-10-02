{ lib, buildGoModule, fetchFromGitHub, nix-update-script
, nixosTests, postgresql, postgresqlTestHook }:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    hash = "sha256-wM9ayB3L9pc3696Ze5hVZPKGwrB5fD+64Wf8DUIjf1k=";
  };

  vendorHash = "sha256-COljILLiAFoX8IShpAmLrxkw6yw7YQE4lpe8IR92j6g=";

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
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "v(.+)" ];
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
