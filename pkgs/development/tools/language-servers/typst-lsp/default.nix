{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z6IG0qJXzwisazR/tLq6dwsZzgzhYKh/NnKmnYySS18=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "elsa-1.8.1" = "sha256-/85IriplPxx24TE/CsvjIsve100QUZiVqS0TWgPFRbw=";
      "svg2pdf-0.5.0" = "sha256-v/ARFI+Uw5KtLe2F3ty9u3uKkWSradRmLnD2VJ+jmSI=";
      "typst-0.5.0" = "sha256-obUe9OVQ8M7MORudQGN7zaYjUv4zjeh7XidHHmUibTA=";
    };
  };

  patches = [
    # typst-library tries to access the workspace with include_bytes, which
    # fails when it is vendored as its own separate crate
    # this patch moves the required assets into the crate and fixes the issue
    # see https://github.com/typst/typst/pull/1515
    ./move-typst-assets.patch
  ];

  meta = with lib; {
    description = "A brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda GaetanLepage ];
  };
}
