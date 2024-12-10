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

  # only build sync server
  cargoBuildFlags = [
    "--bin"
    "anki-sync-server"
  ];

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
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
