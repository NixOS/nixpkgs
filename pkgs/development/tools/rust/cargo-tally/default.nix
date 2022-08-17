{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.9";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-KwR//7UpVoxreQVBY4/GawdU9Bk0d2Qj9EW3odvofc0=";
  };

  cargoSha256 = "sha256-myqSki5pBT01bsJcEy92HkZHbLaWT+5Tl5u4LEUmlK4=";

  buildInputs = lib.optionals stdenv.isDarwin [
    DiskArbitration
    Foundation
    IOKit
  ];

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    homepage = "https://github.com/dtolnay/cargo-tally";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
