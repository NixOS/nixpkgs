{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.3.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-mnX5ZetwOo0VMBIOqJEBpqnSX6EqBEO7qwfgtGclReQ=";
  };

  cargoSha256 = "sha256-SUoreAuWLxtBWmFdLDviDz16oVDB2ubTY3a3m+t8xx0=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
