{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.34";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8PlWRWP5ZsbZ3R/yqA9bUScG0w+gk5YLcIOqwWishVM=";
  };

  cargoHash = "sha256-+Ti8un+y9aNPsz9rUjmTZ6nxVCeQObiZrCYrD6dwr4c=";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    DiskArbitration
    Foundation
    IOKit
  ]);

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
