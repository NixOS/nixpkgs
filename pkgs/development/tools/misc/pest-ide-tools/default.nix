{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-update-script
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "pest-ide-tools";
  version = "0.3.11";
  cargoHash = "sha256-ZD8UQbkk5JhkanBkzo+c86DZE4aD44ma5cN97aKx97U=";

  src = fetchFromGitHub {
    owner = "pest-parser";
    repo = "pest-ide-tools";
    rev = "v${version}";
    sha256 = "sha256-12/FndzUbUlgcYcwMT1OfamSKgy2q+CvtGyx5YY4IFQ=";
  };
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "IDE support for Pest, via the LSP";
    homepage = "https://pest.rs";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "pest-language-server";
  };
}
