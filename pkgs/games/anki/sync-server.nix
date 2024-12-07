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
