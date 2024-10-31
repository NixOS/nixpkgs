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
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "sqld";
  version = "0.24.18";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "libsql";
    rev = "libsql-server-v${version}";
    hash = "sha256-/0Sk55GBjUk/FeIoq/hGVaNGB0EM8CxygAXZ+ufvWKg=";
  };

  cargoBuildFlags = [
    "--bin"
    "sqld"
  ];

  cargoHash = "";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "console-api-0.5.0" = "sha256-MfaxtzOqyblk6aTMqJGRP+123aK0Kq7ODNp/3lehkpQ=";
      "hyper-rustls-0.24.1" = "sha256-dYN42bnbY+4+etmimrnoyzmrKvCZ05fYr1qLQFvzRTk=";
      "rheaper-0.2.0" = "sha256-u5z6J1nmUbIQjDDqqdkT0axNBOvwbFBYghYW/r1rDHc=";
      "s3s-0.10.1-dev" = "sha256-y4DZnRsQzRNsCIp6vrppZkfXSP50LCHWYrKRoIHYPik=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    zstd
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  # requires a complex setup with podman for the end-to-end tests
  doCheck = false;

  meta = {
    description = "LibSQL with extended capabilities like HTTP protocol, replication, and more";
    homepage = "https://github.com/tursodatabase/libsql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
