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
  version = "0.3.2";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Qe9KKZh0Zim/BdPn2aMxkH6FBOBB6zijkp5ft9YfzzU=";
  };

  cargoHash = "sha256-KuVSpbAfLVIy5YJ/8qb+Rfw1TgZkWfR+Ai9gDcf4EQ4=";

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
