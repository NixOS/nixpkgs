{
  lib,
  rustPlatform,
  anki,

  openssl,
  pkg-config,
  buildPackages,
}:

rustPlatform.buildRustPackage {
  pname = "anki-sync-server";
  inherit (anki) version src cargoLock;

  # only build sync server
  cargoBuildFlags = [
    "--bin"
    "anki-sync-server"
  ];

  checkFlags = [
    # this test is flaky, see https://github.com/ankitects/anki/issues/3619
    # also remove from anki when removing this
    "--skip=deckconfig::update::test::should_keep_at_least_one_remaining_relearning_step"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.PROTOC = lib.getExe buildPackages.protobuf;

  meta = {
    description = "Standalone official anki sync server";
    homepage = "https://apps.ankiweb.net";
    license = with lib.licenses; [ agpl3Plus ];
    maintainers = with lib.maintainers; [ martinetd ];
    mainProgram = "anki-sync-server";
  };
}
