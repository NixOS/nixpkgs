{
  pnpm-fixup-state-db,
  testers,
  sqlite,
}:
testers.runCommand {
  name = "pnpm-fixup-state-db-test";

  nativeBuildInputs = [
    pnpm-fixup-state-db
    sqlite
  ];

  script = ''
    install -Dm644 ${./index.db} ./store/index.db

    # Set arbitrary versions as this basic test shouldn't touch any workarounds
    # for later versions
    export NIXPKGS_PNPM_VERSION=11.0.0
    export NIXPKGS_PNPM_FETCHER_VERSION=0

    pnpm-fixup-state-db ./store

    sqlite3 ./store/index.db .dump > $out
  '';

  hash = "sha256-PEzcJgGRo+dK5X9TBcx3A+BOIsvJ7gFmzV8vanTuGCo=";
}
