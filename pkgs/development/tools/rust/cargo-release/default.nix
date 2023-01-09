{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
, curl
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "refs/tags/v${version}";
    hash = "sha256-ggB6gDlIuHPgJJg9TsHXHOKAm7+6OjXzoAT74YUB1n8=";
  };

  cargoHash = "sha256-gBVcQzuJNDwdC59gaOYqvaJDP46wJ9CglYbSPt3zkZ8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    curl
  ];

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/sunng87/cargo-release";
    changelog = "https://github.com/crate-ci/cargo-release/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gerschtli ];
  };
}
