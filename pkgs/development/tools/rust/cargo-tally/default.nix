{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.25";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NoRA0l00TVk27ZOmYzGHxbWah08zLl1gL2caw8LT3I4=";
  };

  cargoSha256 = "sha256-K77opkbNZWymmWMxekSkdiCqmmwccxEqhRcPnrzHWVQ=";

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
