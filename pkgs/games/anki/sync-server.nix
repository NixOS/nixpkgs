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

  patches = [
    ./patches/Cargo.lock-update-time-for-rust-1.80.patch
  ];

  # only build sync server
  cargoBuildFlags = [
    "--bin"
    "anki-sync-server"
  ];

  checkFlags = [
    # these two tests are flaky, see https://github.com/ankitects/anki/issues/3353
    # Also removed from anki when removing this.
    "--skip=media::check::test::unicode_normalization"
    "--skip=scheduler::answering::test::state_application"
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
