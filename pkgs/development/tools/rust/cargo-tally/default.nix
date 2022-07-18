{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NGYXe94eHvRQNxJgH7EiQaL9S+dtNlUrpVSWWQ/wHWY=";
  };

  cargoSha256 = "sha256-vXhZyVMKa/itc+loKuSkSqIWyS3VSowOg1QRS213DPo=";

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
