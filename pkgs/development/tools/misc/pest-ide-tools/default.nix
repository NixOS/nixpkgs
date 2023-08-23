{ lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "pest-ide-tools";
  version = "0.3.3";
  cargoSha256 = "sha256-TXsRGkhswxxLCPOk1qMTvDjs4de1sClRJMr/0o6u4Pg=";

  src = fetchFromGitHub {
    owner = "pest-parser";
    repo = "pest-ide-tools";
    rev = "v${version}";
    sha256 = "sha256-XAdQQFU8ZF0zarqCB6WlhpZVNqNyX6e4np4Wjalhobo=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "IDE support for Pest, via the LSP.";
    homepage = "https://pest.rs";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "pest-language-server";
  };
}
