{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UY7HfUNssOgEuBBPpUFJZs1TM4IT0/kRcjqrXPFoShI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "elsa-1.8.1" = "sha256-/85IriplPxx24TE/CsvjIsve100QUZiVqS0TWgPFRbw=";
      "svg2pdf-0.4.1" = "sha256-WeVP+yhqizpTdRfyoj2AUxFKhGvVJIIiRV0GTXkgLtQ=";
      "typst-0.4.0" = "sha256-S8J2D87Zvyh501d8LG69in9om/nTS6Y+IDhJvjm/H0w=";
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
