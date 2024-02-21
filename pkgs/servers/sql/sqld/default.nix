{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, openssl
, sqlite
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sqld";
  version = "0.22.22";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "libsql";
    rev = "libsql-server-v${version}";
    hash = "sha256-lMuHskx9Sth8v813UeQR/emXkjJYa+NH/lWMQE+8Vw0=";
  };

  patchPhase = ''
    cp Cargo.lock libsql-server
  '';

  cargoRoot = "libsql-server";

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "console-api-0.5.0" = "sha256-MfaxtzOqyblk6aTMqJGRP+123aK0Kq7ODNp/3lehkpQ=";
      "hyper-rustls-0.24.1" = "sha256-dYN42bnbY+4+etmimrnoyzmrKvCZ05fYr1qLQFvzRTk=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    sqlite
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
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
