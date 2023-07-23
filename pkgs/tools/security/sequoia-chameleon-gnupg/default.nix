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
  version = "0.3.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sxjWd02INP2Dr5RQR7+dHHIQkGoCx6CZmvrq9x9zVC8=";
  };

  cargoHash = "sha256-+0MLfq2Gjs4oh9bC8OEQsx0RHxlzB/HlIgyXtwzvGUY=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    nettle
    openssl
    sqlite
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
