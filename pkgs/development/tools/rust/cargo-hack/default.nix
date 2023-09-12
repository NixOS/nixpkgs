{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-uS0QDRSitwCGlo36OvtpjJ6ejKetjYEAuNEZpGiplQs=";
  };

  cargoSha256 = "sha256-Tro0Yp91P9CB/Md6MqbZGkw03QKUe8gh80357mWKMMY=";

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
