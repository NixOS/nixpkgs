{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.20";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-hkw7I9JFTRspYzXtKbpbOVN9sPzUxrRiTL2WjJukY/c=";
  };

  cargoHash = "sha256-DKqcwzAyR0drodDVlccXRSRjjAapJ6nP4aS0CtKtGX4=";

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
