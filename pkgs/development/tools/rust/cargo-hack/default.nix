{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
<<<<<<< HEAD
  version = "0.6.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-uS0QDRSitwCGlo36OvtpjJ6ejKetjYEAuNEZpGiplQs=";
  };

  cargoSha256 = "sha256-Tro0Yp91P9CB/Md6MqbZGkw03QKUe8gh80357mWKMMY=";
=======
  version = "0.5.28";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-434imb66AINKeW50ITc4RRYO9v7sH3fs1DEwSBc3mys=";
  };

  cargoSha256 = "sha256-oDrpQskQV5hG9Ksp0TJcXjm/J9q/K831mOzxH+CXjfg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
