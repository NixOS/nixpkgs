{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    sha256 = "sha256-H0NC+rKRnHaLPHUSYMdkQHfIgQignrTlNCfDwYpro7I=";
  };

  cargoSha256 = "sha256-C7YUAq0b8HyDZx++TT3Elr4hxgtyaRrVXCxOdRwpTFU=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    changelog = "https://github.com/regexident/cargo-modules/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago ];
  };
}
