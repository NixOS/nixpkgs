{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    hash = "sha256-dfeY9YylHF1QHNv7yTNYxUBxzcb276H80WL6JgXR/KY=";
  };

  cargoHash = "sha256-elzLO2YNDsD9FjCW0+2pUWgcJzOvzK+lyZBxrjVXoA8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    changelog = "https://github.com/regexident/cargo-modules/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ figsoda rvarago matthiasbeyer ];
  };
}
