{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.30";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5k4nx4VSYN4jscCwj5NVYnV5/GS0PRCA23xR6STHr88=";
  };

  cargoHash = "sha256-eyGDizffuIPpa797YplD6763/JlVtoMAxybK9KsgmLE=";

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
