{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.25";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1X2/C9JNTuRWY9nke3c7S1x5HuomDs0Em+v0P1HU4aQ=";
  };

  cargoSha256 = "sha256-Ylo0HeIlXEJg6g93u4QMGTbzBtU2EpHW5BWIBDCX+EU=";

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
