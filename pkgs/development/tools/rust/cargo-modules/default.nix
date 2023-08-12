{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    hash = "sha256-3yvrIUvAlnAjEMnBTgDTY8gRW7rILu2Yns/A7lse2Qw=";
  };

  cargoHash = "sha256-Coh+gg2s4esdByQG6iNlG/VqftP+Gg0qaPoPArim1yQ=";

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
