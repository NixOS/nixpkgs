{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.19";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-uBiqmJueSNDB1wWmWvSGR9qPV5NA8yVnl+GyAea30J4=";
  };

  cargoSha256 = "sha256-X7p+tBcFvDL9PEeLkl0Ab/BqpJan0wJX9WCRjHek6u0=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/taiki-e/cargo-hack";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
