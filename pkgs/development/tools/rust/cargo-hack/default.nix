{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.5.29";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Z3UExZghVw7Pbgh5nHuiC8cFVefBE0yZ2k5laam8myY=";
  };

  cargoSha256 = "sha256-5X3MX2KV87mOcN/cL/lFU9K9/j04zn5C7teIXFqj7Wk=";

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
