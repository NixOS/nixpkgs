{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, pkg-config
, nettle
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-chameleon-gnupg";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8aKT39gq6o7dnbhKbDxewd4R2e2IsbYU8vaDwYemes8=";
  };

  cargoHash = "sha256-Z6cXCHLrK+BcIeVCKH2l8n9SivZsZPhXGhaMObn6rjo=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    nettle
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
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
