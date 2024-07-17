{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mchprs";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "MCHPR";
    repo = "MCHPRS";
    rev = "v${version}";
    hash = "sha256-y1ILZvnDWVlghvUVe8xU5wP2TMW+Q/l+V+bqDZrpnBk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hematite-nbt-0.5.2" = "sha256-knBmH/32JJclhFZbKTNx5XgLSQ2rIrXUGu8uoAHAXMk=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      openssl
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    mainProgram = "mchprs";
    description = "A multithreaded Minecraft server built for redstone";
    homepage = "https://github.com/MCHPR/MCHPRS";
    license = licenses.mit;
    maintainers = with maintainers; [ gdd ];
  };
}
