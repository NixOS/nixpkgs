{ lib, rustPlatform, fetchCrate, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
<<<<<<< HEAD
  version = "1.0.29";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SCxigQ6jhT+r6ixgCGwWDtvU8WUJ+5eWYe8DIWPBWhY=";
  };

  cargoSha256 = "sha256-ZX2T+wKIgYJqOK6118wmsMBKigtJvPqJ2hVtyh23zUk=";
=======
  version = "1.0.26";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ojfDujEnwMwzgGklrR5iYJzRzOwn08vmAC1/v6N93kg=";
  };

  cargoSha256 = "sha256-aYZsMyMz5IpkOontFQ2g09F+UjTmluOAlrbD+4etxKw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
