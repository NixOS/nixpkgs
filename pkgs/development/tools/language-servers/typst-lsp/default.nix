{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  # Please update the corresponding vscode extension when updating
  # this derivation.
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = "typst-lsp";
    rev = "v${version}";
    hash = "sha256-OubKtSHw9L4GzVzZY0AVdHY7LzKg/XQIhUfUc2OYAG0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
      "typstfmt_lib-0.2.7" = "sha256-LBYsTCjZ+U+lgd7Z3H1sBcWwseoHsuepPd66bWgfvhI=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  checkFlags = [
    # requires internet access
    "--skip=workspace::package::external::remote_repo::test::full_download"
  ] ++ lib.optionals stdenv.isDarwin [
    # both tests fail on darwin with 'Attempted to create a NULL object.'
    "--skip=workspace::fs::local::test::read"
    "--skip=workspace::package::external::manager::test::local_package"
  ];

  # workspace::package::external::manager::test::local_package tries to access the data directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    mainProgram = "typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda GaetanLepage ];
  };
}
