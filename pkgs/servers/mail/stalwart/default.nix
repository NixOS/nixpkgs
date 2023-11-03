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
  version = "0.4.2";
in
rustPlatform.buildRustPackage {
  pname = "stalwart-mail";
  inherit version;

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "mail-server";
    rev = "v${version}";
    hash = "sha256-Ah53htK38Bm2yGN44IiC6iRWgxkMVRtrNvXXvPh+SJc=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyper-util-0.0.0" = "sha256-9vp8eWjK/pjkJCMjVSI9J2b4amhXK5sat1VAq5Jd6mI=";
      "jmap-client-0.3.0" = "sha256-TJQEi2qH/92QA3YJrPBWgpO0nE5o7Atv6btq2gPNTmw=";
      "mail-auth-0.3.6" = "sha256-FTC0ZHyZ5H2yBlmNrOijm50xQ3qd2Q+52z8THCW5A5Q=";
      "mail-builder-0.3.1" = "sha256-JPV3vp/5+9yFoNNZzxuQ9sbnF8HgDbfHhtb6zQfLFqQ=";
      "mail-parser-0.9.1" = "sha256-PJh6s7SvspakhuziEy+dZccIN0hJpjkcIUGTYQRvKGc=";
      "mail-send-0.4.1" = "sha256-WK6pC8ZtSoIScanNatDbb3Y7Ch43Dj3463VHDwmEyG0=";
      "sieve-rs-0.3.1" = "sha256-PJ24mwlpA6EpB3l749HfSFQhYAmpPxKmYJh/nBmDKDs=";
      "smtp-proto-0.1.1" = "sha256-C73wm+dfq+LKteHH9wATw2L23YMw3dhzTIyFJMoqvBA=";
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
