{ lib, rustPlatform, fetchCrate, stdenv, DiskArbitration, Foundation, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-hsKrkLkHD5NM3sSVHKIa/dxiW5TszryX8bksGqpZ9fI=";
  };

  cargoSha256 = "sha256-9ozabY3tsgQa6nsSsF07juOM+oFJSXGcYOz3uju/tLg=";

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
