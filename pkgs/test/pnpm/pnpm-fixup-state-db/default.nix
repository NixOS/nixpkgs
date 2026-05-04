{
  pnpm-fixup-state-db,
  runCommand,
  sqlite,
}:
runCommand "pnpm-fixup-state-db-test"
  {
    nativeBuildInputs = [
      pnpm-fixup-state-db
      sqlite
    ];

    outputHash = "sha256-8dplPQrvTX19ibsPVf59LqMFS4rArjhAkP5h0JxquSQ=";
    outputHashAlgo = "sha256";
  }
  ''
    install -Dm644 ${./index.db} ./store/index.db

    pnpm-fixup-state-db ./store

    cp ./store/index.db $out
  ''
