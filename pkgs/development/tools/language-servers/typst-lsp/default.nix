{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WLfGrYrhOXesdlyDwUb2iUgTAHW1ASolT/JjGKq60OU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "lipsum-0.8.2" = "sha256-deIbpn4YM7/NeuJ5Co48ivJmxwrcsbLl6c3cP3JZxAQ=";
      "typst-0.0.0" = "sha256-0fTGbXdpzPadABWqdReQNZf2N7OMZ8cs9U5fmhfN6m4=";
    };
  };

  cargoHash = "sha256-ISkw0lhUKJG8nWUHcR93sLUFt5dDEyK7EORcOXEmVbE=";

  meta = with lib; {
    description = "A brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
