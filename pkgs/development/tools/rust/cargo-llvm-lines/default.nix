{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.37";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-9l6WkPVcc1BTRjmHa3+2Y1buLdHC5VIvpGys0fDwldY=";
  };

  cargoHash = "sha256-MbjV3O9yDC8GHWdhWh4/sO+QfAd3kw3K5wLkZ8OlXIU=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    changelog = "https://github.com/dtolnay/cargo-llvm-lines/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
