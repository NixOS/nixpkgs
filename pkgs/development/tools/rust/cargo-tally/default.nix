{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.20";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fhZR8bP8hSCkghRL0uOR0GBeIQtDa2+vzpsjgZq7yio=";
  };

  cargoSha256 = "sha256-7446cO7DkHy2PAPQg+nlwrHxBQhQh5AUOu+jXLKo61U=";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    DiskArbitration
    Foundation
    IOKit
  ]);

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    homepage = "https://github.com/dtolnay/cargo-tally";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
