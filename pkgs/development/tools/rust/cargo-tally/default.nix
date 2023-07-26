{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.27";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Nit2CRhshbNWHRJhQAEYqgulfQGD19OToepp/M7O2DU=";
  };

  cargoSha256 = "sha256-mRl+x0oXomOS3VK6NpVIrGhv3Q27Ez7RHiuaR8L5rGk=";

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
    maintainers = with maintainers; [ figsoda ];
  };
}
