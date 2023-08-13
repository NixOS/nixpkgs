{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, bzip2
, openssl
, sqlite
, zstd
, stdenv
, darwin
, nix-update-script
}:

let
  version = "0.3.4";
in
rustPlatform.buildRustPackage {
  pname = "stalwart-mail";
  inherit version;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "mail-server";
    rev = "v${version}";
    hash = "sha256-SFHlcoc/8wCWPFGHOvU3SIVztBtW4nxU5/pvZzbjzsg=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyper-util-0.0.0" = "sha256-wGtB6hUjIOKR7UZJrX9ve4x4/7TDQuSPG0Sq9VyW7iI=";
      "jmap-client-0.3.0" = "sha256-GNqSPygiVq5Z9y8Kfhzacq3lTIEg2o4UxzOMDbBO7xY=";
      "mail-auth-0.3.2" = "sha256-CTafQCXPo91ZUlfS9JUqU+RfUf4+6EbdG97+nIqQtNw=";
      "mail-builder-0.3.1" = "sha256-r32iiHtQp0C94Qqc4Vspc08QaXZ+e1u7e39fNYoQGsY=";
      "mail-parser-0.8.2" = "sha256-XvKEgzQ+HDoLI16CmqE/RRgApg0q9Au9sqOOEpZz6W0=";
      "mail-send-0.4.0" = "sha256-bMPI871hBj/RvrW4kESGS9XzfnkSo8r2/9uUwgE12EU=";
      "sieve-rs-0.3.1" = "sha256-FJBQorFRXQYhiCzprAqiv69Qae9YI5OAipjayooFDAw=";
      "smtp-proto-0.1.1" = "sha256-HhKZQHQv3tMEfRZgCoAtyxVzwHbcB4FSjKlMoU1PkHg=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    bzip2
    openssl
    sqlite
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # Tests require reading to /etc/resolv.conf
  doCheck = false;

  passthru.update-script = nix-update-script { };

  meta = with lib; {
    description = "Secure & Modern All-in-One Mail Server (IMAP, JMAP, SMTP)";
    homepage = "https://github.com/stalwartlabs/mail-server";
    changelog = "https://github.com/stalwartlabs/mail-server/blob/${version}/CHANGELOG";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
