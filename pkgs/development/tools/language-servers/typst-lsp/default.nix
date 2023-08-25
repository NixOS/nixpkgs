{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = "typst-lsp";
    rev = "v${version}";
    hash = "sha256-qbmNZFXg+XaDkHdBA3dU0ICKovEQrl7AAcMkElMLbMA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires internet access
    "--skip=workspace::package::external::remote_repo::test::full_download"
  ];

  # workspace::package::external::manager::test::local_package tries to access the data directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda GaetanLepage ];
  };
}
