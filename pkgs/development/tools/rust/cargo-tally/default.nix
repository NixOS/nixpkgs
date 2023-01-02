{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.21";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YEsgXIZ4R2w0HOkTV8LOGi2g32nHRs63nhk9yVR4vak=";
  };

  cargoSha256 = "sha256-jLbYC862fZONvMHh0CLsiuUmn/hmAF6sRLuav3P+bck=";

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
