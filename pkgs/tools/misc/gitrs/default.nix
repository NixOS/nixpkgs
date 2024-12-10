{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  libiconv,
  darwin,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitrs";
  version = "v0.3.6";

  src = fetchFromGitHub {
    owner = "mccurdyc";
    repo = pname;
    rev = version;
    hash = "sha256-+43XJroPNWmdUC6FDL84rZWrJm5fzuUXfpDkAMyVQQg=";
  };

  cargoHash = "sha256-2TXm1JTs0Xkid91A5tdi6Kokm0K1NOPmlocwFXv48uw=";

  nativeBuildInputs = [
    pkg-config # for openssl
  ];

  buildInputs =
    [ openssl.dev ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "A simple, opinionated, tool, written in Rust, for declaratively managing Git repos on your machine";
    homepage = "https://github.com/mccurdyc/gitrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mccurdyc ];
    mainProgram = "gitrs";
  };
}
