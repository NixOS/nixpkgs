{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bjgGJxAHc3D0j+ZIPPzBw9vJJgchW9hy5E/qCmFjDUw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "elsa-1.8.1" = "sha256-/85IriplPxx24TE/CsvjIsve100QUZiVqS0TWgPFRbw=";
      "typst-0.2.0" = "sha256-3vNJmLmbskAzXVXjiSVDLhRcX1j3ksOgPd53W31YZ0c=";
    };
  };

  cargoHash = "sha256-ISkw0lhUKJG8nWUHcR93sLUFt5dDEyK7EORcOXEmVbE=";

  meta = with lib; {
    description = "A brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${src.rev}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda GaetanLepage ];
  };
}
