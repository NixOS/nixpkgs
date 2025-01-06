{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, pkg-config
, nettle
, openssl
, sqlite
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-chameleon-gnupg";
  version = "unstable-2023-11-22";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "fd9df5a4e1ec3c3ca986a1a25bacf13f024c934a";
    hash = "sha256-OxWlkOQxuuCFyLMx+ucervyqIduUpyJ9lCGFQlfEUFc=";
  };

  cargoHash = "sha256-4+PA1kYJgn8yDAYr88DQYg6sdgSN3MWzKAUATW3VO6I=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    nettle
    openssl
    sqlite
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # gpgconf: error creating socket directory
  doCheck = false;

  meta = with lib; {
    description = "Sequoia's reimplementation of the GnuPG interface";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
