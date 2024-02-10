{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.17";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-suZkrbxhKFFGfRJDRw6MEc135Xk5Ace3MpKgN7lRnmc=";
  };

  cargoHash = "sha256-9SQ45f5X3fQeYmemES4t6d4M+2/LEBkgQDYgjuy1J5I=";

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
