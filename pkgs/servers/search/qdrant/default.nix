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
  rust-jemalloc-sys-unprefixed,
}:

rustPlatform.buildRustPackage rec {
  pname = "qdrant";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    tag = "v${version}";
    hash = "sha256-77BuXTrQPtg7lus4WXukYSrJllR9hBMqn8+xAaq96z8=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-r+UilkSsV875j7tNkGJxuR/XC8Y1Fk4nqHYah9Z9q9c=";

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs =
    [
      openssl
      rust-jemalloc-sys
      rust-jemalloc-sys-unprefixed
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
