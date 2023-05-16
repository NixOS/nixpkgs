{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, pkg-config
, nettle
, openssl
<<<<<<< HEAD
, sqlite
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-chameleon-gnupg";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Qe9KKZh0Zim/BdPn2aMxkH6FBOBB6zijkp5ft9YfzzU=";
  };

  cargoHash = "sha256-KuVSpbAfLVIy5YJ/8qb+Rfw1TgZkWfR+Ai9gDcf4EQ4=";
=======
    hash = "sha256-8aKT39gq6o7dnbhKbDxewd4R2e2IsbYU8vaDwYemes8=";
  };

  cargoHash = "sha256-Z6cXCHLrK+BcIeVCKH2l8n9SivZsZPhXGhaMObn6rjo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    nettle
    openssl
<<<<<<< HEAD
    sqlite
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
