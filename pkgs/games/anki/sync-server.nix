{
  lib,
  stdenv,
  rustPlatform,
  anki,
  darwin,

  openssl,
  pkg-config,
  protobuf,
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
    protobuf
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env.PROTOC = lib.getExe protobuf;

  meta = with lib; {
    description = "Standalone official anki sync server";
    homepage = "https://apps.ankiweb.net";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ martinetd ];
    mainProgram = "anki-sync-server";
  };
}
