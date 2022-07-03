{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-LHkj+RiUF7Zg2egEDgpViAlhZEhrOBMgLaNdhk5BNFI=";
  };

  cargoSha256 = "sha256-am5AcgqRpMzCNvrfqreyTHqSxxI9qlqUmGU/SVW7TMY=";

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
