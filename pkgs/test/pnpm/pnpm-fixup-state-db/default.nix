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

    pnpm-fixup-state-db ./store

    cp ./store/index.db $out
  '';

  hash = "sha256-tjpKgdMvDcs0X65PENIsiHELYPzVupEH3jS4PyLsF40=";
}
