{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.21";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-E0YhpfFT1JQzXWK3cQfieZ8TVg+BRGwHL6cTwOrNVSQ=";
  };

  cargoSha256 = "sha256-AfILqelDRJuVVEoOT2FLKHq4QVEZXbwPSM0s4fpP00A=";

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
