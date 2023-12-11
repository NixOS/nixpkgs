{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dtool";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "guoxbin";
    repo = "dtool";
    rev = "v${version}";
    hash = "sha256-m4H+ANwEbK6vGW3oIVZqnqvMiAKxNJf2TLIGh/G6AU4=";
  };

  cargoHash = "sha256-r8r3f4yKMQgjtB3j4qE7cqQL18nIqAGPO5RsFErqh2c=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkType = "debug";

  meta = with lib; {
    description = "A command-line tool collection to assist development written in RUST";
    homepage = "https://github.com/guoxbin/dtool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linuxissuper ];
    mainProgram = "dtool";
  };
}
