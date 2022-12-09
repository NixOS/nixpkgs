{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.18";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-BlWPdZb85XaTGV6ZE3XRVKHJyXimfrezhRyqJVmCFMY=";
  };

  cargoSha256 = "sha256-1qtlsItLP8MdxebgktzTr3R4Kq+PBIAiHGaikbQ796E=";

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
