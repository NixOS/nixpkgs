{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.46";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wQo9HDVb7m+FdrMnNVAESEK3k3wrsZYvVpIMu2YNhS8=";
  };

  cargoHash = "sha256-tj9bbT7UlsVbEibtomB7rFK/V6Jdo5K0uoeuXw1yq+o=";

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
