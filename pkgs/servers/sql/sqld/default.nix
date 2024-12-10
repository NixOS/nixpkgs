{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
  sqlite,
  zstd,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "sqld";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "libsql";
    repo = "sqld";
    rev = "v${version}";
    hash = "sha256-KoEscrzkFJnxxJKL/2r4cY0oLpKdQMjFR3daryzrVKQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libsqlite3-sys-0.26.0" = "sha256-JzSGpqYtkIq0mVYD0kERIB6rmZUttqkCGne+M4vqTJU=";
      "octopod-0.1.0" = "sha256-V16fOlIp9BCpyzgh1Aei3Mra/y15v8dQFA8tHdOwZm4=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      openssl
      sqlite
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  # requires a complex setup with podman for the end-to-end tests
  doCheck = false;

  meta = {
    description = "LibSQL with extended capabilities like HTTP protocol, replication, and more";
    homepage = "https://github.com/libsql/sqld";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
