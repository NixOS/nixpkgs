{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, nix-update-script
, nixosTests
, postgresql
, postgresqlTestHook
}:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    hash = "sha256-Hy3QuwAHmZSsjy5A/1mrmrxdtle466HsQtDat3tYS8s=";
  };

  vendorHash = "sha256-M7ogR1ya+sqlWVQpaXlvJy9YwhdM4XBDw8e2ZBPvEGY=";

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

  # PostgreSQL's request for a shared memory segment exceeded your kernel's SHMALL parameter
  doCheck = !(stdenv.isDarwin && stdenv.isx86_64);

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
