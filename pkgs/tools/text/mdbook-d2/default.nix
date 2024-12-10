{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-d2";
  version = "unstable-2023-03-30";

  src = fetchFromGitHub {
    owner = "danieleades";
    repo = "mdbook-d2";
    rev = "93f3037ad9730d134c929cfc90d9bd592a48a1a9";
    hash = "sha256-cmmOmJHARIBCQQEsffnBh4nc2XEDPBzLPcCrOwfTKS8=";
  };

  cargoHash = "sha256-ACwEWK5upeRLo7HU+1kKunecnEeZm0ufUaQjJkXM/4I=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "D2 diagram generator plugin for MdBook";
    mainProgram = "mdbook-d2";
    homepage = "https://github.com/danieleades/mdbook-d2";
    changelog = "https://github.com/danieleades/mdbook-d2/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      blaggacao
      matthiasbeyer
    ];
  };
}
