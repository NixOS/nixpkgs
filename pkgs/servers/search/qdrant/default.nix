{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  stdenv,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
  nix-update-script,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "qdrant";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    tag = "v${version}";
    hash = "sha256-q99roKqeC8lra29gyJertJLnVNFvKRFZ2agREvHZx6k=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tar-0.4.41" = "sha256-32n96yoGbDzhgVZvISLGwxHuv7PGtxde5ma/YlsR1Gg=";
      "wal-0.1.2" = "sha256-QcyS0v7O1BziVT3oahebpq+u4l5JGaujCaRIPdmsJl4=";
    };
  };

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs =
    [
      openssl
      rust-jemalloc-sys
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
